# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **SQL Server database schema and business logic repository** for an ERP/Accounting Payment System (ACPAY). All code is T-SQL targeting SQL Server. The system manages contracts, payments, customers, vendors, inventory, manufacturing, and HR for a Taiwanese enterprise.

**Primary database:** `acpay`
**Secondary database:** `cfp`
**Language:** T-SQL with Chinese column names and comments (Traditional Chinese / Taiwan)

## Architecture

### Module Numbering System

Directories use numeric/alphabetic prefixes mapping to business domains:

| Prefix | Domain | Example Table |
|--------|--------|---------------|
| 00 | Timers & Monitoring | `timer_eep`, `timer_cust` |
| 91 | Configuration & Master Data | `eep_depa`, `eep_curr` |
| 92 | Accounting & Chart of Accounts | `eep_acci`, `eep_coce` |
| 93 | Human Resources | `eep_empl`, `eep_atte` |
| 94 | Sales & Customers | `eep_cust`, `eep_sale`, `eep_area` |
| 95 | Purchasing & Vendors | `eep_fact`, `eep_purc` |
| 96 | Inventory & Materials | `eep_ware`, `eep_item` |
| 97 | Manufacturing | `eep_mach` |
| 98 | Production | `eep_wkct`, `eep_bom` |
| 99 | System Configuration | `eep_comp`, `eep_sysp` |
| 61A | 商品組合 BOM 主檔 | `eep_bmh`, `系統別`, `eep_bmd` |
| 62J | 一盤領用（出庫） | `eep_toh`, `eep_tod` |
| 62K | 一盤繳庫（入庫） | `eep_trh`, `eep_trd` |
| 66D | 庫存調發（調撥） | `eep_tdh`, `eep_tdd` |
| 66H | 庫存日結 | `stka_itea`, `stka_clitea` |
| a0 | Customer Service | — |
| b0 | Work Orders | — |
| e0 | Contract Changes | `pos`, `pos_log` |
| z1 | Utility Functions | `uf_strzero`, `uf_契約編號` |

Each module directory is named: `{prefix}_{Chinese description}_{table_name}` (e.g., `94A_客戶代碼_eep_cust`).

### File Naming Conventions

| Prefix | Type | Purpose |
|--------|------|---------|
| `tb_` | Table | CREATE TABLE definitions |
| `tr_` | Trigger | AFTER INSERT/UPDATE/DELETE triggers |
| `ep_` | Event Procedure | Post-save logic (存後), timer execution |
| `up_` | Update Procedure | Business logic procedures |
| `vi_` | View | SELECT views for reporting |
| `uf_` | Function | User-defined scalar functions |

Trigger naming: `tr_{sequence}_{module}_{sub}_{table}` — the sequence number (010, 100, 110) controls execution order.

### Standard Audit Trail Columns

Every `eep_*` table includes:

- `menuflag char(20)` — Menu identifier, auto-set by AFTER INSERT trigger (format: `{module}_00_{uf_strzero(num,13)}`)
- `flowflag char(50)` — Process flow state
- `chjernoi nvarchar(99)` — Created-by info (建檔資訊)
- `chjernou nvarchar(99)` — Updated-by info (修改資訊)
- `chjernoc` — Closed-by info (結案)
- `chjernop` — Posted-by info (過帳)
- `chjernov` — Voided-by info (作廢)
- `chjernoz` — Approved-by info (核准)
- `remark nvarchar(max)` — Rich remarks/documentation

### Timer/Monitoring Pattern (00/)

31 timer modules monitor business events. Each contains:
- `ep_timer_{entity}.sql` — Execution procedure
- `ep_timer_{entity}_del.sql` — Cleanup procedure
- `tr_{seq}_timer_{entity}.sql` — Triggers

### WMS 庫存追蹤架構 (claude/wms/)

三層 trigger chain 即時追蹤庫存異動，全部由 T-SQL trigger + stored procedure 驅動，前端零開發。

**第一層：來源表 → mes_itio（庫存異動明細）**

| 來源表 | Trigger | ioseqseq | ioqty 規則 |
|--------|---------|----------|-----------|
| `eep_trd` (入庫) | `tr_011_eep_trd_mes_itio` | `TRD ` | +ABS(trqty) |
| `eep_tod` (出庫) | `tr_011_eep_tod_mes_itio` | `TOD ` | -ABS(toqty) |
| `eep_tdd` (調撥) | `tr_011_eep_tdd_mes_itio` | `TDDO`/`TDDI` | -ABS/+ABS(tdqty) |
| `pos_tod` (合約) | `tr_011_pos_tod_mes_itio` | `TDD-`/`TDD+` | -qty |

這些 trigger 僅在 **AFTER UPDATE, DELETE** 觸發。INSERT 時由 `tr_100` 設定 menuflag，觸發 UPDATE，間接觸發 `tr_011`。

**第二層：mes_itio → mes_itea1~4（每日彙總）**

`tr_mes_itio_sync` (AFTER INSERT, UPDATE, DELETE) 收集受影響的 (itemno, posino, wareno, plantno, compno)，呼叫 `sp_recalc_itea`：

| 表 | 維度 | PK |
|----|------|-----|
| `mes_itea1` | compno (公司) | (iodate, itemno, compno) |
| `mes_itea2` | plantno (工廠) | (iodate, itemno, plantno) |
| `mes_itea3` | wareno (倉庫) | (iodate, itemno, wareno) |
| `mes_itea4` | posino (儲位) | (iodate, itemno, posino) |

每日彙總欄位：`OpeningQuantity`、`InboundQuantity`、`OutboundQuantity`、`ClosingQuantity`，使用 window function 計算累計餘額。無異動的日期不保留。

**第三層：mes_itea → mes_mmbe1~4（即時庫存快照）**

`sp_recalc_mmbe` 取每個 (itemno, 階層碼) 在 mes_itea 中最後一天的 ClosingQuantity 寫入 mes_mmbe：

| 表 | 維度 | PK |
|----|------|-----|
| `mes_mmbe1` | compno | (itemno, compno) |
| `mes_mmbe2` | plantno | (itemno, plantno) |
| `mes_mmbe3` | wareno | (itemno, wareno) |
| `mes_mmbe4` | posino | (itemno, posino) |

**mes_level（階層組合完整性）**

`tr_mes_itio_level` (AFTER INSERT, UPDATE, DELETE) 獨立於 `tr_mes_itio_sync`，負責維護 `mes_level` 表，確保所有出現在 `mes_itio` 中的 `(compno, plantno, wareno, posino)` 組合都存在於 `mes_level`。INSERT 時新增缺少的組合，DELETE 時移除已無對應資料的組合。

| 表 | PK |
|----|-----|
| `mes_level` | (compno, plantno, wareno, posino) |

**階層解析規則：**
- `posino`：若來源無 posino，以 wareno 代入
- `plantno`：優先用來源表的 plantno → eep_ware.plantno → wareno
- `compno`：優先用 eep_plant.compno → 預設 `公司代碼`

### 庫存模組完整 Trigger 清單

| 表 | Trigger | 事件 | 用途 |
|----|---------|------|------|
| `eep_tdd` | `tr_100_66d_10_eep_tdd` | INSERT | menuflag |
| `eep_tdd` | `tr_011_eep_tdd_mes_itio` | UPDATE,DELETE | → mes_itio |
| `eep_tdh` | `tr_100_66d_00_eep_tdh` | INSERT | menuflag |
| `eep_tdh` | `tr_010_66d_00_timer_eep` | UPDATE | → timer_eep |
| `eep_tod` | `tr_100_62j_10_eep_tod` | INSERT | menuflag |
| `eep_tod` | `tr_011_eep_tod_mes_itio` | UPDATE,DELETE | → mes_itio |
| `eep_toh` | `tr_100_62j_00_eep_toh` | INSERT | menuflag |
| `eep_toh` | `tr_010_62j_00_timer_eep` | UPDATE | → timer_eep |
| `eep_trd` | `tr_100_62k_10_eep_trd` | INSERT | menuflag |
| `eep_trd` | `tr_011_eep_trd_mes_itio` | UPDATE,DELETE | → mes_itio |
| `eep_trh` | `tr_100_62k_00_eep_trh` | INSERT | menuflag |
| `eep_trh` | `tr_010_62k_00_timer_eep` | UPDATE | → timer_eep |
| `pos_tod` | `tr_011_pos_tod_mes_itio` | UPDATE,DELETE | → mes_itio |
| `mes_itio` | `tr_mes_itio_sync` | INSERT,UPDATE,DELETE | → sp_recalc_itea → sp_recalc_mmbe |
| `mes_itio` | `tr_mes_itio_level` | INSERT,UPDATE,DELETE | → mes_level 完整性維護 |

### Contract Change Pattern (e0_主約變更/)

The `up_e01_zy.sql` procedure implements field-level change tracking, comparing old vs. new values and recording diffs as `舊值→新值` in the remark field.

### 跨伺服器資料表同步 (claude/dbsync/)

`sync_db.py` — 把 source 的指定資料表單向同步到 target，每次執行都重新比對。
完全由 schema 驅動（沒有寫死欄位名或資料表名），換表 / 換庫只需改 `sync_config.json`。

**目前設定：** `192.168.50.7 / AC` → `192.168.50.53,8001 / ac`
**同步的表：** `INVMA` `INVMB` `PURTG` `PURTH` `PURTI` `PURTJ`（共 880 列）

```
1. 讀 source schema（sys.columns + PK）；target 缺表就照 source 建（含 PK、collation、DEFAULT）
2. 兩邊各算 SELECT <PK>, HASHBYTES('SHA2_256', 全欄位串接) → {pk: hash}
3. source有/target無→INSERT；hash不同→UPDATE；target有/source無→DELETE
4. 只撈有異動的 PK 的完整列寫入 target（每表獨立 transaction）
5. 再比對一次驗證差異為 0
```

| 設計要點 | 說明 |
|----------|------|
| **target 欄位一律建成 `Chinese_Taiwan_Stroke_CI_AS`** | 由 `options.target_collation` 控制（`null` = 沿用 source）。source 是 BIN 較嚴格，CI_AS 不分大小寫/全半形/假名，故寫入前會先檢查主鍵是否撞鍵，有衝突就中止該表 |
| 改定序要 `--rebuild` | 既有 target 表定序不符時程式拒絕執行；`--rebuild` 會 DROP 該表後依 source 重建重灌（只動 target） |
| hash 前每欄明確 CONVERT | 避免不同 SQL 版本的隱含轉換格式差異；`float` 用 style 3、日期用 126、binary 用 2 |
| NULL 哨符 `NCHAR(1)`、分隔符 `NCHAR(2)` | 沒有分隔符時 `('a','bc')` 與 `('ab','c')` 會 hash 相同 |
| 事後自動再驗一次 | 抓「每次跑都更新同一批列」的假異動（表示 hash 表示式兩邊不一致） |
| 前提 | 每張表都要有主鍵；identity / FK / 索引 / trigger 不在同步範圍 |

用法：`python sync_db.py [--dry-run] [--tables A,B] [--no-delete] [--schema-only] [--rebuild]`，
exit code 0=成功 / 1=有表失敗。詳見 `claude/dbsync/SKILL.md`。

## Deployment Order

SQL scripts must be executed against the target database in this order:

1. Tables (`tb_*.sql`) — schema definitions
2. Functions (`uf_*.sql`) — dependencies for triggers/procedures
3. Views (`vi_*.sql`)
4. Stored Procedures (`ep_*.sql`, `up_*.sql`)
5. Triggers (`tr_*.sql`) — depend on tables and functions existing

Each SQL file follows the pattern: DROP IF EXISTS → SET options → CREATE.

## Database Connection

### 正式環境（遠端）

| 項目 | 值 |
|------|------|
| server | `163.17.141.61,8081` |
| database | `acpay` |
| user | `casper` |
| password | `CasChrAliJimJam` |
| MCP 工具 | `mcp__sqlserver-nutc__*`（連的是 port 8081，schema 可能不同） |

### 內網環境（192.168.50.53）

| 項目 | 值 |
|------|------|
| server | `192.168.50.53,8000` |
| database | `acpay` |
| user | `drlee` |
| password | `ACpos#1234` |
| 連線方式 | pymssql 直連（`server='192.168.50.53', port=8000`） |
| MCP 工具 | 無（一律用 pymssql） |

> 此環境 schema 與遠端 8081 **不同**（例如 `eep_item` 只有 13 個欄位、無 `chjernoz`），
> 匯入前務必在此伺服器上查 `INFORMATION_SCHEMA.COLUMNS`。

### AC 同步環境（source 192.168.50.7 → target 192.168.50.53,8001）

| 端 | server | database | 帳密 | 版本 / 定序 |
|----|--------|----------|------|-------------|
| source | `192.168.50.7`（預設 1433） | **`AC`** | `drlee` / `ACpos#1234` | SQL 2022 / `Chinese_Taiwan_Stroke_BIN` |
| target | `192.168.50.53,8001` | `ac` | `drlee` / `ACpos#1234` | SQL 2025 / `Chinese_Taiwan_Stroke_CI_AS` |

> **192.168.50.7 的伺服器層級定序是 BIN（區分大小寫），資料庫名稱大小寫必須完全正確。**
> 連到不存在的資料庫名會回報 `18456 登入失敗`（不是「找不到資料庫」），很容易誤判成帳密錯誤。
> 先連 `master` 查 `sys.databases` 確認正確大小寫。
> 這台上面 `AC` / `ACT` / `ACTest` 是三個不同的資料庫，不要混用。

> `192.168.50.53,8001` 與 `192.168.50.53,8000` 是**不同 instance**，8001 為 SQL 2025。
> 8001 上有 `ac` 與 `actest` 兩個資料庫（皆為同步目標，目前使用 `ac`）。

同步程式見 `claude/dbsync/`（`sync_db.py`），詳細設計見 `claude/dbsync/SKILL.md`。

### 本機環境

| 項目 | 值 |
|------|------|
| server | `.\SQLEXPRESS` |
| 靜態 TCP port | `8000`（instance 有設靜態埠，pymssql/pyodbc 用 `localhost,8000` 亦可） |
| database | `acpay` |
| 驗證方式 | **Windows 驗證**（`Trusted_Connection=yes`）— SQL 帳號 `sa/6153` 目前登入失敗（error 18456），改用 Windows 驗證 |
| ODBC driver | `ODBC Driver 17 for SQL Server` |
| MCP 工具 | `mcp__sqlserver-local__*` |

> **注意：** 本機 SQL 帳號 `sa/6153` 已無法登入（伺服器為 mixed mode，但 sa 密碼不符或已停用）。
> 本機作業一律用 **pyodbc + Windows 驗證**；`pymssql` 對具名 instance 支援不佳，需改指定 `localhost` 加 port。

### 連線注意事項

- **查 schema 務必用 pymssql 直連目標伺服器**，MCP 工具 `mcp__sqlserver-nutc__*` 連的是 port 8081
- **`sys.columns.max_length` 對 `nchar`/`nvarchar` 是位元組數**，要除以 2 才是字元數
  （`max_length=2` 代表 `nchar(1)`）；`char`/`varchar`/`binary` 則直接就是長度，`-1` 代表 `max`
- **登入失敗 18456 不一定是帳密錯**：連到不存在的資料庫名也會回報 18456。
  先連 `master` 確認資料庫名稱（含大小寫，BIN 定序的伺服器會區分）
- **定序（Collation）標準為 `Chinese_Taiwan_Stroke_CI_AS`**，所有 SQL 操作遇到定序不一致時，一律轉換成此定序。JOIN、WHERE、ORDER BY 涉及中文欄位比對時加 `COLLATE Chinese_Taiwan_Stroke_CI_AS`
- **tempdb 定序為 `Chinese_Taiwan_Stroke_90_CI_AS`**，與 acpay 不同。Trigger 內建立 `#temp` table 時，nvarchar 欄位必須加 `COLLATE Chinese_Taiwan_Stroke_CI_AS`，否則與 `inserted`/`deleted` 比對會報 collation conflict
- nvarchar 欄位寫入中文時，值前面要加 `N` 前綴（如 `N'中文'`）
- `num` 欄位為 identity（自動編號），INSERT 時不需指定
- **欄位名可能含尾端空白**：192.168.50.53 的 `eep_item` 有一欄實際名稱是 `itemna `（結尾一個空白），
  SQL 中必須寫成 `[itemna ]`，否則報 Invalid column name
- **char 欄位比對為大小寫不分（CI 定序）**：`WHERE itemno='BLUEKA'` 會命中 `Blueka`，
  以 itemno 當 key 做 upsert 時，大小寫不同的兩筆會被視為同一筆

### 連線範例

```python
# 正式環境（遠端）— pymssql
import pymssql
conn = pymssql.connect(server='163.17.141.61', port=8081, user='casper', password='CasChrAliJimJam', database='acpay', charset='utf8')

# 內網環境 192.168.50.53 — pymssql
conn = pymssql.connect(server='192.168.50.53', port=8000, user='drlee', password='ACpos#1234', database='acpay', charset='utf8')

# 本機 — pyodbc + Windows 驗證（sa/6153 已無法登入，改用此法）
import pyodbc
cs = r'DRIVER={ODBC Driver 17 for SQL Server};SERVER=.\SQLEXPRESS;DATABASE=acpay;Trusted_Connection=yes;'
conn = pyodbc.connect(cs)
# pyodbc 已原生支援 unicode 參數，中文值不需手動加 N 前綴；SQL 字面值仍需 N'中文'
```

## 對照表（eep_trd vs eep_tod）

eep_trd 和 eep_tod 是結構相似的平行資料表，欄位命名規則不同：

| eep_trd | eep_tod | 說明 |
|---------|---------|------|
| trno | tono | 單號 |
| trseq | toseq | 序號 |
| trqty | toqty | 數量 |
| trno2 | tono2 | 來源單號 |
| trdate | todate | 日期 |
| trtype | totype | 類型 |

匯入 eep_trd 時，通常也需要同步匯入 eep_tod。

### 對照表（eep_tdd 調撥明細）

eep_tdd 是調撥專用明細表，使用 `td` 前綴，且有來源/目的倉庫雙欄位：

| eep_tdd | 說明 |
|---------|------|
| tdno | 單號 |
| tdseq | 序號 |
| tdqty | 數量 |
| warenofm / warenmfm | 來源倉庫代碼/名稱 |
| warenoto / warenmto | 目的倉庫代碼/名稱 |
| tddate | 日期 |

### 對照表（mes_itio 庫存異動）

| 欄位 | 型態 | 說明 |
|------|------|------|
| iono | nvarchar(20) | 來源單號（trno/tono/tdno） |
| ioseq | char(4) | 來源序號 LEFT(xseq, 4) |
| ioseqseq | char(4) | 來源類型（TRD /TOD /TDDO/TDDI/TDD-/TDD+） |
| iodate | char(8) | 異動日期 YYYYMMDD |
| itemno | nvarchar(40) | 物料編號 |
| posino | nvarchar(40) | 儲位（無則=wareno） |
| wareno | nvarchar(40) | 倉庫 |
| plantno | nvarchar(40) | 工廠 |
| compno | nvarchar(40) | 公司 |
| ioqty | decimal(20,2) | 數量（正=入庫, 負=出庫） |

## 關聯表查找規則

匯入明細資料時，以下欄位需從關聯表查找或反向新增：

| 欄位 | 來源 | 規則 |
|------|------|------|
| `unitno` | `eep_item` | `WHERE eep_item.itemno = 資料.itemno` |
| `warenm` | `eep_ware` | `WHERE eep_ware.wareno = 資料.wareno`；找不到時反向新增 eep_ware |
| `clasno` | `eep_clas` | `WHERE eep_clas.clasnm = 資料.clasnm`（需 COLLATE）；查不到時留 NULL 並回報 |

### 61A 商品組合（eep_bmh / 系統別）

`系統別` 是 `eep_bmh` 的外鍵參照表，欄位僅 2 個：`系統別代號 nvarchar(20) NOT NULL`、`系統別名稱 nvarchar(40)`。

**已知系統別代號（截至 2026-08-24）：**

| 代號 | 名稱 | 來源 |
|------|------|------|
| BA | 餐飲軟體系統 | 既有 |
| EI | 電子發票服務 | eep_bmh 舊資料補建（非 Excel 匯入） |
| KDS | KDS軟體 | eep_bmh 舊資料補建（非 Excel 匯入） |
| NK | 新餐飲管理系統 | 既有 |
| NK/PA | NK/PA | 2026-08-24 Excel 匯入新增 |
| PA | 餐飲管理系統(軟體租賃) | 既有 |
| PA/PKD/PKR | PA/PKD/PKR | 2026-08-24 Excel 匯入新增 |
| PF | 數位管理系統 | 既有 |
| PKD | 開店快手餐飲(長期租賃) | 既有 |
| PKR | 開店快手零售(長期租賃) | 既有 |
| PM | 會員與訂位系統 | 既有 |
| PR | 開店快手(短期租賃) | 既有 |
| PS | 開店快手(快捷版租賃) | 既有 |
| PZ | 餐飲管理系統 | 既有 |
| PZ/PA | PZ/PA | 2026-08-24 Excel 匯入新增 |

> **注意：** 匯入 `eep_bmh` 後務必執行完整性驗證：
> ```sql
> -- eep_bmh 所有系統別代號必須在 系統別 有對應
> SELECT b.系統別代號 FROM eep_bmh b
> LEFT JOIN 系統別 s ON s.系統別代號 = b.系統別代號
> WHERE s.系統別代號 IS NULL GROUP BY b.系統別代號
> ```
> EI / KDS 是 eep_bmh 中既有的舊代號，不在 Excel 匯入範圍內，需手動補建到 `系統別`。

## Working with This Codebase

- 查 schema、匯入資料時，使用 pymssql 直連目標伺服器（見上方 Database Connection）
- **匯入前一定要在目標伺服器上查 INFORMATION_SCHEMA.COLUMNS**，不要依賴 MCP 工具的 schema
- 讀取 xlsx 時使用 `openpyxl`，若有公式欄位需用 `data_only=True`
- `menuflag` 由 AFTER INSERT trigger 自動設定，INSERT 時指定的值會被覆蓋
- `uf_strzero(num, length)` is a core utility that zero-pads integers to a specified width
- Column comments in table DDL (after `--`) document the Chinese field name/purpose
