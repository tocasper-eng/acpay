# SKILL.md — XLSX / CSV 匯入 SQL Server 標準作業流程

本文件記錄將 xlsx / csv 檔案匯入 acpay 資料庫的完整步驟與踩坑經驗。

---

## 適用場景

使用者提供：
- 一個 xlsx 或 csv 檔案
- 目標資料表名稱（如 `eep_trd`、`eep_item`）
- 欄位對應規則與限制條件
- key field（存在即覆蓋 = upsert）
- 驗證條件（如 `SELECT SUM(qty), COUNT(*) ...`）

---

## 標準步驟

### Step 1：讀取 xlsx / csv 結構

```python
import openpyxl
wb = openpyxl.load_workbook('檔案路徑.xlsx', data_only=True)  # data_only=True 取公式計算值
ws = wb.active
headers = [cell.value for cell in ws[1]]
```

**注意：**
- `data_only=True` 是必須的，否則公式欄位會回傳公式字串而非計算結果
- Python 的 stdout 需設定 utf-8：`sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')`
- 確認總筆數和關鍵欄位加總，提前與驗證條件比對

**csv 版本：**

```python
import csv
with open(path, encoding='utf-8-sig', newline='') as f:   # utf-8-sig 吃掉 BOM
    rows = list(csv.reader(f))
```

- 一定要用 `utf-8-sig`，否則第一個欄名會變成 `﻿itemna`
- Excel 匯出的 csv 常有**多餘的尾端空欄**（header 12 欄、實際只用前 5 欄），
  取值時用 `(row + ['']*5)[:n]` 補齊再切片，並 `.strip()`
- 匯入前先做三項自我檢查：
  1. 各欄位最大長度 vs 目標欄位 `CHARACTER_MAXIMUM_LENGTH`
  2. key field 是否重複（含**大小寫不同**的重複，SQL 為 CI 定序會視為同一筆）
  3. 關聯欄位（如 `clasnm`）的 distinct 值是否都能在關聯表找到

### Step 2：在目標伺服器上查 schema

**絕對不要用 MCP 工具查 schema**，MCP 可能連到不同的伺服器，欄位會不同。

```python
import pymssql
conn = pymssql.connect(server='163.17.141.61', port=8081, user='casper', password='CasChrAliJimJam', database='acpay', charset='utf8')
cursor = conn.cursor()
cursor.execute("""
    SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = '目標表名'
    ORDER BY ORDINAL_POSITION
""")
for row in cursor.fetchall():
    print(row)
```

**踩坑紀錄：**
- MCP `mcp__sqlserver-nutc__*` 連的是 port 8081（與 pymssql 相同）
- 曾因此漏掉 `itemna`、`clasno`、`clasnm` 三個欄位，事後用 UPDATE 補回
- **不同伺服器同名資料表 schema 不同**：192.168.50.53:8000 的 `eep_item` 只有 13 欄，
  沒有 `chjernoz`；欄名 `itemna ` 結尾帶一個空白，SQL 要寫 `[itemna ]`
- 順手查 trigger，才知道 INSERT/UPDATE 會有什麼副作用：
  ```sql
  SELECT name FROM sys.triggers WHERE parent_id = OBJECT_ID('eep_item')
  SELECT OBJECT_DEFINITION(OBJECT_ID('tr_100_96d_00_eep_item'))
  ```
  `eep_item`：`tr_100` after insert 補 `menuflag`；`tr_010` after update 寫 `timer_eep`

### Step 3：檢查關聯表並補資料

匯入前檢查以下關聯表，缺少的記錄要先新增：

| 關聯表 | 用途 | 查找方式 |
|--------|------|----------|
| `eep_ware` | 倉庫代碼 | `wareno` → `warenm`；找不到時反向新增 |
| `eep_item` | 物料主檔 | `itemno` → `unitno`；空表時 unitno 為 NULL |
| `eep_clas` | 物料大類 | `clasnm` → `clasno`；需 COLLATE 處理 |

```python
# 查找 xlsx 中的唯一 wareno
wareno_set = {}
for row in ws.iter_rows(min_row=2, max_row=ws.max_row, values_only=True):
    wareno_set[row[8]] = row[9]  # wareno -> warenm

# 檢查哪些不在 eep_ware 中，新增缺少的
for wareno, warenm in wareno_set.items():
    cursor.execute('INSERT INTO eep_ware (wareno, warenm) VALUES (%s, %s)', (wareno, warenm))
```

### Step 4：執行 INSERT

使用 pymssql 批次 INSERT，不要用 MCP 工具。

```python
sql = '''INSERT INTO eep_trd (trno, trseq, itemno, itemnm, itemna, clasno, clasnm, wareno, warenm, trqty, trno2, trdate, menuflag, chjernoi, chjernoz)
         VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)'''

seq = 0
for row in ws.iter_rows(min_row=2, max_row=ws.max_row, values_only=True):
    seq += 10
    trseq = str(seq).zfill(4)  # 0010, 0020, 0030 ...
    params = (
        row[0],         # trno
        trseq,          # trseq
        row[4],         # itemno
        row[7],         # itemnm
        row[3],         # itemna
        row[5],         # clasno
        row[6],         # clasnm
        row[8],         # wareno
        row[9],         # warenm
        row[10],        # trqty
        'TR26060001',   # trno2（固定值）
        '2020-06-30',   # trdate（解析後的日期）
        '62K_00_0000000000001',  # menuflag（會被 trigger 覆蓋）
        'TR26060001',   # chjernoi
        'Y'             # chjernoz
    )
    cursor.execute(sql, params)
conn.commit()
```

**注意事項：**
- `num` 是 identity 欄位，不需指定
- `menuflag` 雖然 INSERT 時指定了值，但 AFTER INSERT trigger 會覆蓋成 `{module}_{seq}_{uf_strzero(num,13)}`
- `trseq` 格式為 4 碼零填充：0010, 0020, 0030 ...

### Step 4b：有 key field 時改用 upsert（存在即覆蓋）

使用者說「key field: itemno，若已經存在就覆蓋其他欄位」時，不要直接 INSERT。
**動手前先備份目標表**（`SELECT * ... ` 存成 csv），再逐筆先 UPDATE、`rowcount == 0` 才 INSERT：

```python
for itemna, itemno, itemnm, clasnm, remark in recs:
    cur.execute("""UPDATE eep_item
                      SET itemnm=%s, clasnm=%s, remark=%s, [itemna ]=%s
                    WHERE itemno=%s""", (itemnm, clasnm, remark, itemna, itemno))
    if cur.rowcount == 0:
        cur.execute("""INSERT INTO eep_item (itemno, itemnm, clasnm, remark, [itemna ])
                       VALUES (%s,%s,%s,%s,%s)""", (itemno, itemnm, clasnm, remark, itemna))
conn.commit()
```

**注意：**
- 檔案內同一 key 出現多次時，後者覆蓋前者（符合「已存在就覆蓋」語意），但要主動回報
- `itemno` 是 `char(20)`，SQL 比對自動忽略尾端空白，不需自己 rstrip
- CI 定序下 `'BLUEKA'` 與 `'Blueka'` 是同一筆，DB 內既有的大小寫**不會**被改寫

### Step 5：用 UPDATE 補查找欄位

INSERT 後，用 JOIN 從關聯表更新查找欄位：

```sql
-- clasno 從 eep_clas 查找（需 COLLATE 處理）
UPDATE t
SET t.clasno = c.clasno
FROM eep_trd t
INNER JOIN eep_clas c
  ON c.clasnm COLLATE Chinese_Taiwan_Stroke_CI_AS = t.clasnm COLLATE Chinese_Taiwan_Stroke_CI_AS
WHERE t.trno = 'TR26060001'
```

**踩坑紀錄：**
- 不加 COLLATE 會報錯：`Cannot resolve the collation conflict between "Chinese_Taiwan_Stroke_CI_AS" and "Chinese_PRC_CI_AS"`
- 這是因為 eep_trd 和 eep_clas 的 collation 不同

### Step 6：同步匯入平行表（eep_tod）

eep_trd 和 eep_tod 是平行表，欄位名不同但結構相同：
- `trno` → `tono`、`trseq` → `toseq`、`trqty` → `toqty` 等

匯入 eep_trd 後，通常也要匯入 eep_tod，使用相同的 xlsx 資料但對應不同欄位名。

### Step 7：驗證

```python
cursor.execute("SELECT COUNT(*), SUM(trqty) FROM eep_trd WHERE trno = 'TR26060001'")
r = cursor.fetchone()
print(f'count={r[0]}, sum={r[1]}')  # 預期: count=218, sum=13972
```

upsert 類匯入則做**逐欄逐筆回比**，比只看筆數可靠：

```python
# key 以 upper() 正規化（配合 CI 定序），再比對每個匯入欄位
db = {r[0].upper(): r for r in cur.fetchall()}
print('檔案有 DB 沒有:', sorted(set(recs) - set(db)))
print('欄位不符:', [k for k in recs if k in db and db[k][1:] != recs[k][...]])
```

另外檢查查找欄位有沒有漏填：

```sql
SELECT COUNT(*) FROM eep_item t
LEFT JOIN eep_clas c
  ON c.clasnm COLLATE Chinese_Taiwan_Stroke_CI_AS = t.clasnm COLLATE Chinese_Taiwan_Stroke_CI_AS
WHERE c.clasno IS NOT NULL AND (t.clasno IS NULL OR RTRIM(t.clasno) <> RTRIM(c.clasno))
```

---

## 踩坑總結

| 問題 | 原因 | 解法 |
|------|------|------|
| schema 欄位缺少 | MCP 連的是不同伺服器 | 用 pymssql 直連目標伺服器查 INFORMATION_SCHEMA |
| xlsx 公式欄位回傳公式字串 | openpyxl 預設回傳公式 | 加 `data_only=True` |
| Collation conflict 錯誤 | 兩表 collation 不同 | JOIN 條件加 `COLLATE Chinese_Taiwan_Stroke_CI_AS` |
| menuflag 值被覆蓋 | AFTER INSERT trigger 自動設定 | 這是正常行為，不需處理 |
| eep_ware 沒寫入目標伺服器 | MCP execute 寫到了另一台 | 用 pymssql 直連目標伺服器寫入 |
| Python stdout 中文亂碼 | Windows 預設編碼非 utf-8 | `sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')` |
| eep_tod 漏匯 | 只注意到 eep_trd | eep_trd 和 eep_tod 是平行表，需同步匯入 |
| csv 第一欄名多了 `﻿` | 檔案有 UTF-8 BOM | `open(..., encoding='utf-8-sig')` |
| csv 每列多出一堆空欄 | Excel 匯出的尾端空欄 | `(row + ['']*5)[:n]` 補齊後切片，並 `.strip()` |
| `Invalid column name 'itemna'` | 欄名結尾真的有一個空白 | 寫成 `[itemna ]`；先查 INFORMATION_SCHEMA 確認 |
| 兩筆不同大小寫的 key 只進了一筆 | char 欄位是 CI 定序 | 這是預期行為（後者覆蓋前者），匯入後主動回報 |
| clasno 留 NULL | clasnm 在 eep_clas 找不到（如 `KDS`、空白） | **不要自行新增大類**，留 NULL 並回報使用者決定 |

---

## MCP 工具清單

| MCP 名稱 | 連線目標 | 用途 |
|-----------|----------|------|
| `mcp__sqlserver-nutc__*` | 163.17.141.61:8081 | 遠端正式環境 |
| `mcp__sqlserver-local__*` | `.\sqlexpress` | 本機 SQL Express |
| （無 MCP） | 192.168.50.53:8000 `drlee` | 內網環境，一律 pymssql 直連 |

**建議：** 匯入資料時不要依賴 MCP，一律用 pymssql 直連目標伺服器。MCP 適合快速查詢，不適合需要精確 schema 的作業。

---

## 任務範本

使用者下次只需提供（csv upsert 版）：

```
請將目錄下的 csv 匯入 eep_item

csv 檔名：商品總表_v6_3432(商品總表).csv
目標伺服器：192.168.50.53,8000 / drlee / acpay
匯入欄位：itemna, itemno, itemnm, clasnm, remark
特殊欄位：clasno = (select clasno from eep_clas where clasnm = eep_item.clasnm)
key field：itemno，已存在就覆蓋其他欄位
```

或（xlsx 純新增版）：

```
請將目錄下的 xlsx 匯入 eep_trd

xlsx 檔名：xxx.xlsx
目標資料表：eep_trd
限制條件：
  trseq = 0010, 0020 ...
  menuflag = 62K_00_0000000000001
  trno2 = TR26060001
  chjernoi = TR26060001
  chjernoz = Y
驗證：select sum(trqty), count(*) from eep_trd where trno = 'TR26060001'
```

不需要再提供伺服器連線資訊（已記錄在 CLAUDE.md）。

---

## WMS 庫存追蹤系統部署記錄

### 系統架構

三層 trigger chain，全部 T-SQL 實現，前端零開發：

```
來源表 (eep_trd/tod/tdd, pos_tod)
  → tr_011_*_mes_itio (AFTER UPDATE,DELETE)
  → mes_itio (庫存異動明細)
    → tr_mes_itio_sync (AFTER INSERT,UPDATE,DELETE)
    → sp_recalc_itea (重算 mes_itea1~4 每日彙總)
    → sp_recalc_mmbe (取最後異動日寫入 mes_mmbe1~4 即時快照)
    → tr_mes_itio_level (AFTER INSERT,UPDATE,DELETE)
    → mes_level (階層組合完整性維護)
```

### 部署順序

1. 表：`mes_itio` → `mes_itea1~4` → `mes_mmbe1~4` → `mes_level`
2. SP：`sp_recalc_mmbe` → `sp_recalc_itea`（itea 呼叫 mmbe）
3. Trigger：`tr_mes_itio_sync` → `tr_mes_itio_level` → `tr_011_eep_trd_mes_itio` 等

### 完整物件清單（已部署至 163.17.141.61:8081）

| 物件 | 類型 | 所在表 | 檔案位置 |
|------|------|--------|----------|
| `mes_itio` | Table | — | `claude/wms/4_資料庫物件/tb_mes_itio.sql` |
| `mes_itea1~4` | Table | — | `claude/wms/4_資料庫物件/tb_mes_itea*.sql` |
| `mes_mmbe1~4` | Table | — | `claude/wms/4_資料庫物件/tb_mes_mmbe*.sql` |
| `sp_recalc_itea` | SP | — | `claude/wms/4_資料庫物件/sp_recalc_itea.sql` |
| `sp_recalc_mmbe` | SP | — | `claude/wms/4_資料庫物件/sp_recalc_mmbe.sql` |
| `mes_level` | Table | — | `claude/wms/4_資料庫物件/tb_mes_level.sql` |
| `tr_mes_itio_sync` | Trigger | `mes_itio` | `claude/wms/4_資料庫物件/tr_mes_itio_sync.sql` |
| `tr_mes_itio_level` | Trigger | `mes_itio` | `claude/mes_level_完整性/tr_mes_itio_level.sql` |
| `tr_011_eep_trd_mes_itio` | Trigger | `eep_trd` | `claude/wms/4_資料庫物件/tr_011_eep_trd_mes_itio.sql` |
| `tr_011_eep_tod_mes_itio` | Trigger | `eep_tod` | `claude/wms/4_資料庫物件/tr_011_eep_tod_mes_itio.sql` |
| `tr_011_eep_tdd_mes_itio` | Trigger | `eep_tdd` | `claude/wms/4_資料庫物件/tr_011_eep_tdd_mes_itio.sql` |
| `tr_011_pos_tod_mes_itio` | Trigger | `pos_tod` | `claude/wms/4_資料庫物件/tr_011_pos_tod_mes_itio.sql` |
| `tr_100_62j_00_eep_toh` | Trigger | `eep_toh` | `62J_一盤領用/.../tr_100_62j_00_eep_toh.sql` |
| `tr_010_62j_00_timer_eep` | Trigger | `eep_toh` | `62J_一盤領用/.../tr_010_62j_00_timer_eep.sql` |
| `tr_100_62k_00_eep_trh` | Trigger | `eep_trh` | `62K_一盤繳庫/.../tr_100_62k_00_eep_trh.sql` |
| `tr_010_62k_00_timer_eep` | Trigger | `eep_trh` | `62K_一盤繳庫/.../tr_010_62k_00_timer_eep.sql` |

### 關鍵設計決策

| 決策 | 說明 |
|------|------|
| tr_011 只有 UPDATE,DELETE | INSERT 由 tr_100 設 menuflag → 觸發 UPDATE → 觸發 tr_011 |
| ioqty 正負號 | 入庫 +ABS，出庫 -ABS |
| posino 預設值 | 無 posino 時以 wareno 代入，長度皆 nvarchar(40) |
| iodate 格式 | char(8) YYYYMMDD，字典序=時間序 |
| mes_itea 不保留零異動日 | 刪除重算，只有實際異動日才有列 |
| mes_mmbe 只存最新快照 | key = (itemno, 階層碼)，取 MAX(iodate) 那列的 ClosingQuantity |
| 調撥雙列 | eep_tdd 產生 TDDO(出庫) + TDDI(入庫) 兩列 mes_itio |

### 踩坑紀錄

| 問題 | 解法 |
|------|------|
| eep_plant 不存在 | 已建立 eep_plant(plantno, plantnm, compno, compnm) |
| compno 預設值 | COALESCE(eep_plant.compno, N'公司代碼') |
| 日期欄位轉換 | CONVERT(char(8), datetime_col, 112) |
| Window function 累計 | ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING 計算 OpeningQuantity |
