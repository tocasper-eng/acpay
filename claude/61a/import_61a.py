"""
import_61a.py — 61A 商品組合 eep_bmh 匯入腳本
用法: python import_61a.py
"""
import sys, io, pymssql, openpyxl

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

XLSX  = r'C:\Users\tocas\Nutstore\1\Obsidian\EEP\35_ACPAY\claude\61a\開店快手軟硬體對照表_20260824_比對.xlsx'
SHEET = '配方明細'
CONN  = dict(server='163.17.141.61', port=8081, user='casper',
             password='CasChrAliJimJam', database='acpay', charset='utf8')

def get_conn(): return pymssql.connect(**CONN)

# ── 讀 Excel ──────────────────────────────────────────
def read_excel():
    wb = openpyxl.load_workbook(XLSX, data_only=True)
    ws = wb[SHEET]
    dedup = {}
    for row in ws.iter_rows(min_row=2, max_row=ws.max_row, values_only=True):
        a, b, c, d = row[0], row[1], row[2], row[3]
        if a and b and d:
            key = (str(a).strip(), str(b).strip(), str(d).strip())
            dedup[key] = str(c).strip() if c else ''
    return dedup  # {(系統別代號, bmno, bmtype): bmnm}

# ── Task 1: 系統別 upsert ────────────────────────────
def task1_syscode(conn, dedup):
    print("=== Task 1: 系統別 ===")
    cur = conn.cursor()
    cur.execute("SELECT 系統別代號 FROM 系統別")
    db_codes = set(r[0].strip() for r in cur.fetchall())

    excel_codes = sorted(set(k[0] for k in dedup.keys()))
    inserted = []
    for code in excel_codes:
        if code not in db_codes:
            cur.execute(
                "INSERT INTO 系統別 (系統別代號, 系統別名稱) VALUES (%s, %s)",
                (code, code)
            )
            inserted.append(code)
    conn.commit()

    if inserted:
        print(f"  新增 {len(inserted)} 筆: {inserted}")
    else:
        print("  無需新增")
    print()

# ── Task 2: ALTER TABLE ADD bmnm ─────────────────────
def task2_add_bmnm(conn):
    print("=== Task 2: ALTER TABLE eep_bmh ADD bmnm ===")
    cur = conn.cursor()
    cur.execute("""
        SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME='eep_bmh' AND COLUMN_NAME='bmnm'
    """)
    if cur.fetchone()[0] == 0:
        cur.execute("ALTER TABLE eep_bmh ADD bmnm nvarchar(60)")
        conn.commit()
        print("  bmnm 欄位已新增 nvarchar(60)")
    else:
        print("  bmnm 欄位已存在，略過")
    print()

# ── Task 3: eep_bmh upsert ───────────────────────────
def task3_upsert(conn, dedup):
    print("=== Task 3: eep_bmh upsert ===")
    cur = conn.cursor()

    cur.execute("SELECT 系統別代號, 系統別名稱 FROM 系統別")
    sys_map = {r[0].strip(): (r[1] or '').strip() for r in cur.fetchall()}

    cur.execute("SELECT 系統別代號, bmno, bmtype FROM eep_bmh")
    existing = set(
        (r[0].strip(), r[1].strip(), r[2].strip())
        for r in cur.fetchall()
    )

    updated, inserted = [], []
    for (sys_no, bmno, bmtype), bmnm in dedup.items():
        sys_nm = sys_map.get(sys_no, sys_no)
        if (sys_no, bmno, bmtype) in existing:
            cur.execute(
                "UPDATE eep_bmh SET bmnm=%s WHERE 系統別代號=%s AND bmno=%s AND bmtype=%s",
                (bmnm, sys_no, bmno, bmtype)
            )
            updated.append((sys_no, bmno, bmtype))
        else:
            cur.execute(
                """INSERT INTO eep_bmh (系統別代號, 系統別名稱, bmno, bmnm, bmtype)
                   VALUES (%s, %s, %s, %s, %s)""",
                (sys_no, sys_nm, bmno, bmnm, bmtype)
            )
            inserted.append((sys_no, bmno, bmtype))
    conn.commit()

    print(f"  UPDATE: {len(updated)} 筆")
    for r in sorted(updated): print(f"    {r[0]} | {r[1]} | {r[2]}")
    print(f"  INSERT: {len(inserted)} 筆")
    for r in sorted(inserted): print(f"    {r[0]} | {r[1]} | {r[2]}")
    print()

# ── 驗證 ──────────────────────────────────────────────
def verify(conn):
    print("=== 驗證 ===")
    cur = conn.cursor()
    cur.execute("SELECT COUNT(*) FROM 系統別")
    print(f"  系統別 筆數: {cur.fetchone()[0]}")
    cur.execute("SELECT COUNT(*) FROM eep_bmh")
    print(f"  eep_bmh 筆數: {cur.fetchone()[0]}")
    cur.execute("SELECT COUNT(*) FROM eep_bmh WHERE bmnm IS NOT NULL AND bmnm <> ''")
    print(f"  eep_bmh bmnm 有值筆數: {cur.fetchone()[0]}")

# ── 主程式 ────────────────────────────────────────────
if __name__ == '__main__':
    dedup = read_excel()
    conn  = get_conn()
    task1_syscode(conn, dedup)
    task2_add_bmnm(conn)
    task3_upsert(conn, dedup)
    verify(conn)
    conn.close()
    print("完成")
