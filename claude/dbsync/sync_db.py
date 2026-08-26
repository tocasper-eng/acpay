#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
SQL Server 跨伺服器資料表單向同步程序
=====================================

程式完全由 schema 驅動，沒有寫死任何欄位名或資料表名；
要同步哪個資料庫、哪些資料表，全部看 sync_config.json。

目前設定（sync_config.json）：

source : 192.168.50.7        / AC   (Chinese_Taiwan_Stroke_BIN, SQL 2022)
target : 192.168.50.53,8001  / ac   (Chinese_Taiwan_Stroke_CI_AS, SQL 2025)

每次執行都會重新比對 source 與 target，單向把 source 的內容寫入 target：

    1. 讀 source schema（sys.columns + PK）
    2. target 沒有該表就依 source 定義建立（含 PK、collation、預設值）
    3. 兩邊各算一次 (PK, row hash)，比對出 INSERT / UPDATE / DELETE
    4. 只把有異動的列從 source 撈完整資料寫入 target
    5. 再比對一次驗證差異為 0

用法:
    python sync_db.py                      # 全部資料表，實際寫入
    python sync_db.py --dry-run            # 只比對不寫入
    python sync_db.py --tables INVMA,PURTG # 指定資料表
    python sync_db.py --no-delete          # 不刪除 target 多出來的列
    python sync_db.py --schema-only        # 只建表 / 補欄位，不同步資料
    python sync_db.py --rebuild            # 定序不符時 DROP 重建該表並重灌

target 欄位定序由 sync_config.json 的 options.target_collation 決定
（設 null 則沿用 source 的定序）。目前設為 Chinese_Taiwan_Stroke_CI_AS。

Exit code: 0 = 全部成功，1 = 有資料表失敗。
"""

from __future__ import annotations

import argparse
import datetime as _dt
import io
import json
import os
import re
import sys
import traceback
from decimal import Decimal

import pymssql

if hasattr(sys.stdout, "buffer"):
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding="utf-8", errors="replace")

HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_CONFIG = os.path.join(HERE, "sync_config.json")
LOG_DIR = os.path.join(HERE, "logs")

# NULL 與欄位分隔用的哨符，取不可能出現在資料中的控制字元
NULL_SENTINEL = "NCHAR(1)"
FIELD_SEPARATOR = "NCHAR(2)"


# --------------------------------------------------------------------------
# logging
# --------------------------------------------------------------------------
class Log:
    def __init__(self, to_file=True):
        self.fh = None
        if to_file:
            os.makedirs(LOG_DIR, exist_ok=True)
            path = os.path.join(LOG_DIR, "sync_%s.log" % _dt.date.today().strftime("%Y%m%d"))
            self.fh = open(path, "a", encoding="utf-8")
            self.path = path

    def __call__(self, msg=""):
        line = "%s %s" % (_dt.datetime.now().strftime("%H:%M:%S"), msg) if msg else ""
        print(line)
        if self.fh:
            self.fh.write(line + "\n")
            self.fh.flush()

    def close(self):
        if self.fh:
            self.fh.close()


# --------------------------------------------------------------------------
# schema introspection
# --------------------------------------------------------------------------
class Column:
    __slots__ = ("name", "type_name", "max_length", "precision", "scale",
                 "is_nullable", "collation", "is_identity", "is_computed", "default_def")

    def __init__(self, row):
        (self.name, self.type_name, self.max_length, self.precision, self.scale,
         self.is_nullable, self.collation, self.is_identity, self.is_computed,
         self.default_def) = row

    @property
    def q(self):
        return "[%s]" % self.name


class TableSchema:
    def __init__(self, name, columns, pk):
        self.name = name
        self.columns = columns                       # list[Column]，含 computed
        self.pk = pk                                 # list[str]
        self.by_name = {c.name: c for c in columns}
        # 同步時真正搬資料的欄位：排除 computed（無法寫入）
        self.data_columns = [c for c in columns if not c.is_computed]

    @property
    def q(self):
        return "[%s]" % self.name

    @property
    def non_pk_columns(self):
        pkset = set(self.pk)
        return [c for c in self.data_columns if c.name not in pkset]


COLUMN_SQL = """
SELECT  c.name,
        ty.name,
        c.max_length,
        c.precision,
        c.scale,
        c.is_nullable,
        c.collation_name,
        c.is_identity,
        c.is_computed,
        dc.definition
FROM    sys.columns c
        JOIN sys.types ty
          ON ty.user_type_id = c.user_type_id
        LEFT JOIN sys.default_constraints dc
          ON dc.parent_object_id = c.object_id
         AND dc.parent_column_id = c.column_id
WHERE   c.object_id = OBJECT_ID(%s)
ORDER BY c.column_id
"""

PK_SQL = """
SELECT  cc.name
FROM    sys.indexes i
        JOIN sys.index_columns ic
          ON ic.object_id = i.object_id AND ic.index_id = i.index_id
        JOIN sys.columns cc
          ON cc.object_id = ic.object_id AND cc.column_id = ic.column_id
WHERE   i.object_id = OBJECT_ID(%s)
  AND   i.is_primary_key = 1
  AND   ic.is_included_column = 0
ORDER BY ic.key_ordinal
"""


def read_schema(conn, table):
    """讀取資料表結構，不存在則回傳 None。"""
    cur = conn.cursor()
    cur.execute(COLUMN_SQL, (table,))
    rows = cur.fetchall()
    if not rows:
        return None
    cur.execute(PK_SQL, (table,))
    pk = [r[0] for r in cur.fetchall()]
    return TableSchema(table, [Column(r) for r in rows], pk)


# --------------------------------------------------------------------------
# DDL generation
# --------------------------------------------------------------------------
_UNSIZED = {
    "int", "bigint", "smallint", "tinyint", "bit", "money", "smallmoney",
    "date", "datetime", "smalldatetime", "uniqueidentifier", "sql_variant",
    "xml", "text", "ntext", "image", "timestamp", "rowversion", "geography",
    "geometry", "hierarchyid",
}
_CHAR_TYPES = {"char", "nchar", "varchar", "nvarchar", "text", "ntext"}


def render_type(col):
    t = col.type_name
    if t in ("nvarchar", "nchar"):
        n = "max" if col.max_length == -1 else col.max_length // 2
        return "%s(%s)" % (t, n)
    if t in ("varchar", "char", "varbinary", "binary"):
        n = "max" if col.max_length == -1 else col.max_length
        return "%s(%s)" % (t, n)
    if t in ("decimal", "numeric"):
        return "%s(%d,%d)" % (t, col.precision, col.scale)
    if t in ("datetime2", "time", "datetimeoffset"):
        return "%s(%d)" % (t, col.scale)
    if t == "float":
        return "float(%d)" % col.precision
    if t in _UNSIZED:
        return t
    return t


def wanted_collation(col, target_collation):
    """這個欄位在 target 應該用什麼定序；非字元型別回傳 None。"""
    if col.type_name not in _CHAR_TYPES or not col.collation:
        return None
    return target_collation or col.collation


def render_column(col, target_collation):
    parts = [col.q, render_type(col)]
    coll = wanted_collation(col, target_collation)
    if coll:
        parts.append("COLLATE %s" % coll)
    if col.is_identity:
        parts.append("IDENTITY(1,1)")
    parts.append("NULL" if col.is_nullable else "NOT NULL")
    if col.default_def:
        parts.append("DEFAULT %s" % col.default_def)
    return " ".join(parts)


def build_create_ddl(schema, target_collation):
    cols = [render_column(c, target_collation) for c in schema.columns if not c.is_computed]
    body = ",\n    ".join(cols)
    if schema.pk:
        body += ",\n    CONSTRAINT [PK_%s] PRIMARY KEY CLUSTERED (%s)" % (
            schema.name, ", ".join("[%s]" % c for c in schema.pk))
    return "CREATE TABLE %s (\n    %s\n)" % (schema.q, body)


# --------------------------------------------------------------------------
# row hashing
# --------------------------------------------------------------------------
def hash_expr_for_column(col):
    """把欄位轉成兩邊伺服器都會產生相同結果的 nvarchar 字串。"""
    t = col.type_name
    if t in ("nvarchar", "nchar", "varchar", "char", "text", "ntext", "xml"):
        conv = "CONVERT(nvarchar(max), %s)" % col.q
    elif t in ("decimal", "numeric", "money", "smallmoney"):
        conv = "CONVERT(nvarchar(50), %s)" % col.q
    elif t in ("int", "bigint", "smallint", "tinyint", "bit"):
        conv = "CONVERT(nvarchar(20), %s)" % col.q
    elif t in ("float", "real"):
        # style 3 = 17 位可還原表示法，避免兩邊浮點格式化差異
        conv = "CONVERT(nvarchar(50), %s, 3)" % col.q
    elif t in ("date", "datetime", "datetime2", "smalldatetime", "time", "datetimeoffset"):
        conv = "CONVERT(nvarchar(50), %s, 126)" % col.q
    elif t in ("binary", "varbinary", "image", "timestamp", "rowversion"):
        conv = "CONVERT(nvarchar(max), CONVERT(varchar(max), %s, 2))" % col.q
    else:
        conv = "CONVERT(nvarchar(max), %s)" % col.q
    return "ISNULL(%s, %s)" % (conv, NULL_SENTINEL)


def check_key_collisions(src, schema, target_collation, log):
    """
    target 定序比 source 寬鬆時，source 兩個不同的主鍵可能在 target 撞成同一筆。

    例：source 是 BIN（區分大小寫），target 是 CI_AS（不分大小寫、不分全半形、
    不分平假名片假名）。source 的 'abc' 與 'ABC' 是兩筆，寫到 target 會違反 PK。

    直接在 source 上用 target 的定序 GROUP BY，讓 SQL Server 自己判斷等價性，
    比在 Python 端模擬定序規則可靠。
    """
    if not target_collation:
        return 0
    pk_cols = [schema.by_name[n] for n in schema.pk]
    if not any(c.type_name in _CHAR_TYPES and c.collation
               and c.collation != target_collation for c in pk_cols):
        return 0
    ex = [("%s COLLATE %s" % (c.q, target_collation)) if c.type_name in _CHAR_TYPES else c.q
          for c in pk_cols]
    sel = ", ".join("%s AS k%d" % (e, i) for i, e in enumerate(ex))
    grp = ", ".join(ex)
    cur = src.cursor()
    cur.execute("SELECT COUNT(*) FROM (SELECT %s, COUNT(*) AS n FROM %s GROUP BY %s "
                "HAVING COUNT(*) > 1) x" % (sel, schema.q, grp))
    n = cur.fetchone()[0]
    if n:
        cur.execute("SELECT TOP 5 %s, COUNT(*) AS n FROM %s GROUP BY %s HAVING COUNT(*) > 1"
                    % (sel, schema.q, grp))
        for r in cur.fetchall():
            log("    衝突鍵：%s（source 有 %d 筆）" % (tuple(r[:-1]), r[-1]))
    return n


def build_keyhash_sql(schema):
    """SELECT <pk...>, <sha256 hex> FROM table"""
    pieces = []
    for c in schema.data_columns:
        pieces.append(hash_expr_for_column(c))
    concat = (" + %s + " % FIELD_SEPARATOR).join(pieces)
    pk_cols = ", ".join("[%s]" % c for c in schema.pk)
    return ("SELECT %s, CONVERT(char(64), HASHBYTES('SHA2_256', %s), 2)\n  FROM %s"
            % (pk_cols, concat, schema.q))


def fetch_keyhash(conn, schema, sql):
    """回傳 {pk_tuple: hash_hex}。"""
    cur = conn.cursor()
    cur.execute(sql)
    n = len(schema.pk)
    out = {}
    while True:
        rows = cur.fetchmany(5000)
        if not rows:
            break
        for r in rows:
            out[tuple(r[:n])] = r[n]
    return out


# --------------------------------------------------------------------------
# diff / apply
# --------------------------------------------------------------------------
class Diff:
    def __init__(self, inserts, updates, deletes):
        self.inserts = inserts      # list[pk_tuple]
        self.updates = updates      # list[pk_tuple]
        self.deletes = deletes      # list[pk_tuple]

    @property
    def total(self):
        return len(self.inserts) + len(self.updates) + len(self.deletes)


def compute_diff(src_map, tgt_map):
    inserts, updates = [], []
    for k, h in src_map.items():
        th = tgt_map.get(k)
        if th is None:
            inserts.append(k)
        elif th != h:
            updates.append(k)
    deletes = [k for k in tgt_map if k not in src_map]
    return Diff(inserts, updates, deletes)


def chunked(seq, size):
    for i in range(0, len(seq), size):
        yield seq[i:i + size]


def fetch_rows_by_pk(conn, schema, keys, batch_size):
    """依 PK 從 source 撈完整列，回傳 list[tuple]（欄位順序 = data_columns）。"""
    cols = ", ".join(c.q for c in schema.data_columns)
    where_one = " AND ".join("[%s] = %%s" % c for c in schema.pk)
    out = []
    cur = conn.cursor()
    for batch in chunked(keys, batch_size):
        clause = " OR ".join("(%s)" % where_one for _ in batch)
        params = tuple(v for k in batch for v in k)
        cur.execute("SELECT %s FROM %s WHERE %s" % (cols, schema.q, clause), params)
        out.extend(cur.fetchall())
    return out


def apply_inserts(conn, schema, rows, batch_size, log):
    if not rows:
        return 0
    cols = schema.data_columns
    sql = "INSERT INTO %s (%s) VALUES (%s)" % (
        schema.q,
        ", ".join(c.q for c in cols),
        ", ".join(["%s"] * len(cols)),
    )
    cur = conn.cursor()
    done = 0
    for batch in chunked(rows, batch_size):
        cur.executemany(sql, batch)
        done += len(batch)
    return done


def apply_updates(conn, schema, rows, batch_size, log):
    if not rows:
        return 0
    cols = schema.data_columns
    idx = {c.name: i for i, c in enumerate(cols)}
    setcols = schema.non_pk_columns
    if not setcols:
        # 整張表都是 PK，hash 不同不可能發生；保險起見略過
        return 0
    sql = "UPDATE %s SET %s WHERE %s" % (
        schema.q,
        ", ".join("%s = %%s" % c.q for c in setcols),
        " AND ".join("[%s] = %%s" % c for c in schema.pk),
    )
    params = [tuple([r[idx[c.name]] for c in setcols] + [r[idx[p]] for p in schema.pk])
              for r in rows]
    cur = conn.cursor()
    done = 0
    for batch in chunked(params, batch_size):
        cur.executemany(sql, batch)
        done += len(batch)
    return done


def apply_deletes(conn, schema, keys, batch_size, log):
    if not keys:
        return 0
    sql = "DELETE FROM %s WHERE %s" % (
        schema.q, " AND ".join("[%s] = %%s" % c for c in schema.pk))
    cur = conn.cursor()
    done = 0
    for batch in chunked(keys, batch_size):
        cur.executemany(sql, batch)
        done += len(batch)
    return done


# --------------------------------------------------------------------------
# target schema alignment
# --------------------------------------------------------------------------
def collation_mismatches(src_schema, tgt_schema, target_collation):
    """回傳 target 定序與設定不符的欄位名清單。"""
    out = []
    for c in src_schema.data_columns:
        want = wanted_collation(c, target_collation)
        t = tgt_schema.by_name.get(c.name)
        if want and t and t.collation and t.collation != want:
            out.append((c.name, t.collation, want))
    return out


def create_target_table(tgt, src_schema, target_collation, dry_run, log, reason):
    ddl = build_create_ddl(src_schema, target_collation)
    log("  %s → CREATE TABLE (%d 欄, PK=%s, collation=%s)"
        % (reason, len(src_schema.data_columns), ",".join(src_schema.pk) or "無",
           target_collation or "沿用 source"))
    if dry_run:
        log("  [dry-run] 略過建表")
        return None
    tgt.cursor().execute(ddl)
    tgt.commit()
    return read_schema(tgt, src_schema.name)


def align_target_schema(tgt, src_schema, tgt_schema, opt, args, log):
    """確保 target 有對應的表與欄位。回傳更新後的 tgt_schema。"""
    dry_run = args.dry_run
    tc = opt.get("target_collation")

    if tgt_schema is None:
        if not opt["create_missing_tables"]:
            raise RuntimeError("target 缺少資料表 %s，且 create_missing_tables=false" % src_schema.name)
        return create_target_table(tgt, src_schema, tc, dry_run, log, "target 無此表")

    # 定序不符 → 只能重建（ALTER COLUMN 改定序要先拆掉 PK 與相依索引，
    # 而 target 是可重建的單向鏡像，直接 DROP + CREATE 更單純也更不易出錯）
    bad = collation_mismatches(src_schema, tgt_schema, tc)
    if bad:
        log("  target 有 %d 個欄位定序不符（例：%s 為 %s，應為 %s）"
            % (len(bad), bad[0][0], bad[0][1], bad[0][2]))
        if not args.rebuild:
            raise RuntimeError("定序不符，需加 --rebuild 重建此表（會 DROP 後依 source 重灌）")
        log("  --rebuild → DROP TABLE 後重建")
        if dry_run:
            log("  [dry-run] 略過重建")
            return None
        tgt.cursor().execute("DROP TABLE %s" % tgt_schema.q)
        tgt.commit()
        return create_target_table(tgt, src_schema, tc, dry_run, log, "重建")

    # 表已存在 → 比對欄位
    missing = [c for c in src_schema.data_columns if c.name not in tgt_schema.by_name]
    extra = [c.name for c in tgt_schema.data_columns if c.name not in src_schema.by_name]
    if extra:
        log("  警告：target 多出 %d 個 source 沒有的欄位（不處理）：%s"
            % (len(extra), ", ".join(extra[:10])))
    if missing:
        if not opt["add_missing_columns"]:
            raise RuntimeError("target %s 缺少欄位 %s，且 add_missing_columns=false"
                               % (src_schema.name, ", ".join(c.name for c in missing)))
        log("  target 缺 %d 個欄位 → ALTER TABLE ADD：%s"
            % (len(missing), ", ".join(c.name for c in missing)))
        if dry_run:
            log("  [dry-run] 略過補欄位")
        else:
            cur = tgt.cursor()
            for c in missing:
                # 補欄位一律允許 NULL，避免既有資料違反 NOT NULL
                col = Column((c.name, c.type_name, c.max_length, c.precision, c.scale,
                              True, c.collation, False, False, None))
                cur.execute("ALTER TABLE %s ADD %s"
                            % (tgt_schema.q, render_column(col, opt.get("target_collation"))))
            tgt.commit()
            tgt_schema = read_schema(tgt, src_schema.name)

    # 型別差異只警告，不自動改（改型別有資料遺失風險）
    for c in src_schema.data_columns:
        t = tgt_schema.by_name.get(c.name) if tgt_schema else None
        if t and render_type(t) != render_type(c):
            log("  警告：欄位 %s 型別不同 source=%s target=%s"
                % (c.name, render_type(c), render_type(t)))
    return tgt_schema


# --------------------------------------------------------------------------
# per-table sync
# --------------------------------------------------------------------------
def sync_table(src, tgt, table, opt, args, log):
    log("")
    log("─" * 68)
    log("[%s]" % table)
    src_schema = read_schema(src, table)
    if src_schema is None:
        raise RuntimeError("source 沒有資料表 %s" % table)
    if not src_schema.pk:
        raise RuntimeError("source 資料表 %s 沒有主鍵，無法做差異同步" % table)

    # target 定序若比 source 寬鬆，先確認不會有兩個 source 主鍵撞成一筆
    n_coll = check_key_collisions(src, src_schema, opt.get("target_collation"), log)
    if n_coll:
        raise RuntimeError(
            "source 有 %d 組主鍵在 target 定序 %s 下會撞成同一筆，無法同步。"
            "請改用 source 定序（target_collation 設為 null）或先清理 source 資料"
            % (n_coll, opt["target_collation"]))

    tgt_schema = read_schema(tgt, table)
    tgt_schema = align_target_schema(tgt, src_schema, tgt_schema, opt, args, log)
    if tgt_schema is None:
        # dry-run 且尚未建表：只能回報將全量新增
        cur = src.cursor()
        cur.execute("SELECT COUNT(*) FROM %s" % src_schema.q)
        n = cur.fetchone()[0]
        log("  [dry-run] 預計新增 %d 列" % n)
        return dict(table=table, ins=n, upd=0, dele=0, status="dry-run")

    if args.schema_only:
        log("  --schema-only：略過資料同步")
        return dict(table=table, ins=0, upd=0, dele=0, status="schema-only")

    # 兩邊都用 source 的欄位清單算 hash，確保 target 多餘欄位不影響比對
    hash_schema = TableSchema(table, src_schema.data_columns, src_schema.pk)
    sql = build_keyhash_sql(hash_schema)
    src_map = fetch_keyhash(src, hash_schema, sql)
    tgt_map = fetch_keyhash(tgt, hash_schema, sql)
    log("  source %d 列 / target %d 列" % (len(src_map), len(tgt_map)))

    diff = compute_diff(src_map, tgt_map)
    n_del = len(diff.deletes) if opt["delete_extra_rows"] and not args.no_delete else 0
    log("  差異：新增 %d / 更新 %d / 刪除 %d%s"
        % (len(diff.inserts), len(diff.updates), n_del,
           ""  if n_del == len(diff.deletes) else " (另有 %d 列 target 多出但不刪除)" % len(diff.deletes)))

    if diff.total == 0:
        log("  已一致，無需處理")
        return dict(table=table, ins=0, upd=0, dele=0, status="ok")

    if args.dry_run:
        log("  [dry-run] 不寫入")
        return dict(table=table, ins=len(diff.inserts), upd=len(diff.updates),
                    dele=n_del, status="dry-run")

    bs = opt["batch_size"]
    try:
        ins = upd = dele = 0
        if opt["delete_extra_rows"] and not args.no_delete and diff.deletes:
            dele = apply_deletes(tgt, tgt_schema, diff.deletes, bs, log)
        if diff.updates:
            rows = fetch_rows_by_pk(src, src_schema, diff.updates, bs)
            upd = apply_updates(tgt, src_schema, rows, bs, log)
        if diff.inserts:
            rows = fetch_rows_by_pk(src, src_schema, diff.inserts, bs)
            ins = apply_inserts(tgt, src_schema, rows, bs, log)
        tgt.commit()
    except Exception:
        tgt.rollback()
        raise
    log("  已寫入：新增 %d / 更新 %d / 刪除 %d" % (ins, upd, dele))

    status = "ok"
    if opt["verify_after_sync"]:
        v_src = fetch_keyhash(src, hash_schema, sql)
        v_tgt = fetch_keyhash(tgt, hash_schema, sql)
        v = compute_diff(v_src, v_tgt)
        remaining = len(v.inserts) + len(v.updates) + (len(v.deletes) if not args.no_delete else 0)
        if remaining == 0:
            log("  驗證：兩邊完全一致 ✓")
        else:
            status = "verify-failed"
            log("  驗證失敗：仍有 新增 %d / 更新 %d / 刪除 %d"
                % (len(v.inserts), len(v.updates), len(v.deletes)))
            for k in (v.inserts + v.updates + v.deletes)[:5]:
                log("    殘留 PK: %s" % (k,))
    return dict(table=table, ins=ins, upd=upd, dele=dele, status=status)


# --------------------------------------------------------------------------
# main
# --------------------------------------------------------------------------
def connect(cfg, label, log):
    conn = pymssql.connect(
        server=cfg["server"], port=cfg.get("port", 1433),
        user=cfg["user"], password=cfg["password"],
        database=cfg["database"], charset="utf8",
        login_timeout=15, timeout=cfg.get("timeout", 300),
    )
    cur = conn.cursor()
    cur.execute("SELECT DB_NAME(), CONVERT(nvarchar(128), SERVERPROPERTY('Collation'))")
    db, coll = cur.fetchone()
    log("%-6s %s:%s / %s (%s)" % (label, cfg["server"], cfg.get("port", 1433), db, coll))
    return conn


def load_config(path):
    with open(path, encoding="utf-8") as f:
        cfg = json.load(f)
    # 密碼可用環境變數覆蓋，避免只依賴檔案內的明碼
    for key, env in (("source", "DBSYNC_SRC_PWD"), ("target", "DBSYNC_TGT_PWD")):
        if os.environ.get(env):
            cfg[key]["password"] = os.environ[env]
    # 定序名會直接串進 SQL（COLLATE 不吃參數），先擋掉非法字元
    tc = cfg["options"].get("target_collation")
    if tc and not re.match(r"^[A-Za-z0-9_]+$", tc):
        raise ValueError("target_collation 含非法字元：%r" % tc)
    return cfg


def main(argv=None):
    ap = argparse.ArgumentParser(description="SQL Server source → target 單向資料表同步")
    ap.add_argument("--config", default=DEFAULT_CONFIG, help="設定檔路徑")
    ap.add_argument("--tables", help="只同步指定資料表，逗號分隔")
    ap.add_argument("--dry-run", action="store_true", help="只比對差異，不寫入 target")
    ap.add_argument("--no-delete", action="store_true", help="不刪除 target 多出來的列")
    ap.add_argument("--schema-only", action="store_true", help="只建表 / 補欄位，不同步資料")
    ap.add_argument("--rebuild", action="store_true",
                    help="target 欄位定序與設定不符時，DROP 該表後依 source 重建並重灌")
    ap.add_argument("--no-verify", action="store_true", help="同步後不再比對驗證")
    ap.add_argument("--no-log-file", action="store_true", help="不寫 logs/ 檔案")
    args = ap.parse_args(argv)

    log = Log(to_file=not args.no_log_file)
    started = _dt.datetime.now()
    log("=" * 68)
    log("資料同步開始  %s%s" % (started.strftime("%Y-%m-%d %H:%M:%S"),
                                "  [DRY-RUN]" if args.dry_run else ""))

    cfg = load_config(args.config)
    opt = cfg["options"]
    if args.no_verify:
        opt["verify_after_sync"] = False
    tables = [t.strip() for t in args.tables.split(",")] if args.tables else cfg["tables"]

    src = tgt = None
    results = []
    try:
        src = connect(cfg["source"], "SOURCE", log)
        tgt = connect(cfg["target"], "TARGET", log)
        for t in tables:
            try:
                results.append(sync_table(src, tgt, t, opt, args, log))
            except Exception as e:
                log("  失敗：%s" % e)
                log(traceback.format_exc())
                results.append(dict(table=t, ins=0, upd=0, dele=0, status="error: %s" % e))
    finally:
        for c in (src, tgt):
            if c:
                try:
                    c.close()
                except Exception:
                    pass

    log("")
    log("=" * 68)
    log("%-10s %8s %8s %8s   %s" % ("TABLE", "INSERT", "UPDATE", "DELETE", "STATUS"))
    log("-" * 68)
    for r in results:
        log("%-10s %8d %8d %8d   %s" % (r["table"], r["ins"], r["upd"], r["dele"], r["status"]))
    log("-" * 68)
    log("合計 新增 %d / 更新 %d / 刪除 %d，耗時 %.1f 秒"
        % (sum(r["ins"] for r in results), sum(r["upd"] for r in results),
           sum(r["dele"] for r in results), (_dt.datetime.now() - started).total_seconds()))

    failed = [r for r in results if r["status"].startswith("error") or r["status"] == "verify-failed"]
    if failed:
        log("失敗資料表：%s" % ", ".join(r["table"] for r in failed))
    log.close()
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
