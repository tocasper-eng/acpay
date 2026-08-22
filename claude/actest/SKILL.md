# SKILL.md — actest 跨伺服器資料表單向同步

本文件記錄 `sync_actest.py` 的設計、驗證方式與踩坑經驗。
適用於「把 A 伺服器的指定資料表，每次執行都重新比對後單向寫入 B 伺服器」這類需求。

---

## 完成任務

### 2026-08-22: actest 六張表 source → target 單向同步

**目標：** 每次執行程序時比對 source 與 target，單向由 source 寫入 target。

| 端 | 伺服器 | 資料庫 | 版本 | 定序 |
|----|--------|--------|------|------|
| source | `192.168.50.7`（預設 1433） | `ACTest` | SQL 2022 | `Chinese_Taiwan_Stroke_BIN` |
| target | `192.168.50.53,8001` | `actest` | SQL 2025 | `Chinese_Taiwan_Stroke_CI_AS` |

**資料表：** `INVMA`(21欄) `INVMB`(176欄) `PURTG`(65欄) `PURTH`(79欄) `PURTI`(59欄) `PURTJ`(53欄)

**產出檔案：**

| 檔案 | 用途 |
|------|------|
| `sync_actest.py` | 主程式 |
| `sync_config.json` | 連線、資料表清單、行為選項 |
| `run_sync.bat` | Windows 工作排程器啟動檔 |
| `logs/sync_YYYYMMDD.log` | 每日執行紀錄（不進版控） |

---

## 演算法

```
1. 讀 source schema（sys.columns + PK），target 沒有該表就照 source 建（含 PK、collation、DEFAULT）
2. 兩邊各跑一次 SELECT <PK>, HASHBYTES('SHA2_256', 全欄位串接) → {pk: hash}
3. 比對：
     source 有、target 無      → INSERT
     兩邊都有但 hash 不同      → UPDATE
     target 有、source 無      → DELETE
4. 只把有異動的 PK 從 source 撈完整列，批次寫入 target（單一 transaction，失敗整批 rollback）
5. 再算一次 hash 比對，確認差異為 0
```

**為什麼用 hash 而不是整表拉回來比：** 176 欄的表全量拉兩份過網路很貴。
只傳 `(PK, 64字元hash)` 後，僅有異動的列才需要撈完整內容。表變大時成本不會爆掉。

---

## 關鍵設計決策

| 決策 | 理由 |
|------|------|
| target 欄位沿用 source 的 `Chinese_Taiwan_Stroke_BIN` 定序 | source 是 BIN（區分大小寫），target DB 是 CI_AS。若不保留，source 中 `'abc'` 與 `'ABC'` 兩筆不同的 PK 在 target 會撞成同一筆 → PK violation |
| hash 前每個欄位都明確 `CONVERT` | 不同 SQL 版本對隱含轉換的格式化可能不同。`numeric`→`nvarchar(50)`、`float`→ style 3（17位可還原）、日期→ style 126、binary→ style 2 hex |
| NULL 用 `NCHAR(1)` 哨符、欄位間用 `NCHAR(2)` 分隔 | 沒有分隔符時 `('a','bc')` 與 `('ab','c')` 會 hash 相同；NULL 不用哨符則與空字串無法區分 |
| 兩邊都用 **source 的欄位清單** 算 hash | target 若多出 source 沒有的欄位，不影響比對結果 |
| 同步後預設再驗一次（`verify_after_sync`） | 若 hash 表示式在兩台機器上格式化不一致，會出現「每次執行都更新同一批列」的假異動。驗證步驟會直接把它抓成 `verify-failed` |
| 每張表獨立 transaction | 一張表失敗不影響其他表；該表整批 rollback，不會留下半套資料 |
| 欄位型別不同只警告不自動改 | ALTER COLUMN 有資料遺失風險，交給人決定 |
| 缺的欄位一律以 NULL 補上 | target 既有資料無法滿足 NOT NULL |

---

## 踩坑紀錄

| 問題 | 原因 | 解法 |
|------|------|------|
| `login failed for user 'drlee'`，但同帳號連 master 成功 | source 伺服器**伺服器層級定序是 BIN（區分大小寫）**，資料庫實際名稱是 `ACTest` 不是 `actest`，連不存在的 DB 會回報 18456 而不是「找不到資料庫」 | 先連 `master` 查 `sys.databases` 確認正確大小寫 |
| `nchar(2)` 塞不下 `'ZZ'` | `sys.columns.max_length` 對 `nchar`/`nvarchar` 是**位元組數**，2 bytes = 1 個字元 | 產 DDL 時 `max_length // 2`；`varchar`/`char` 則直接用 |
| target 是空資料庫（0 張表） | 目標端從未建過表 | 程式需自帶 DDL 產生能力，不能假設 target 已有 schema |
| `numeric` 欄位怕兩邊格式化不同 | 同型別 `numeric(p,s)` 的 `CONVERT(nvarchar)` 小數位固定，實測 SQL 2022 與 2025 一致 | 已由 idempotent 測試證實（第二次執行差異 0） |

---

## 驗證方式

實測結果（2026-08-22）：

| 測試 | 結果 |
|------|------|
| 首次同步（target 空庫） | 6 張表建立完成，876 列寫入，全部 `驗證：兩邊完全一致 ✓` |
| **冪等性**：立即再跑一次 | 新增 0 / 更新 0 / 刪除 0 — 證明跨 SQL 2022↔2025、跨定序的 hash 穩定 |
| UPDATE 路徑：竄改 target 一列 | 偵測到 1 筆更新並修復 |
| INSERT 路徑：刪掉 target 一列 | 偵測到 1 筆新增並補回 |
| DELETE 路徑：在 target 插入 source 沒有的列 | 偵測到 1 筆刪除並移除 |
| **獨立驗證**（不使用程式自己的 hash） | 兩邊全部欄位逐列逐欄用 Python 比對 → 6 張表全部相同 |
| 錯誤隔離：指定不存在的表 | 該表標記 `error`，其餘照常同步，exit code = 1 |

**獨立驗證是必要的**：只用程式自己的 hash 驗證，等於用同一套邏輯自我背書；
hash 表示式若有 bug（例如漏掉某欄），兩邊都會漏、驗證照樣通過。
務必另外寫一段「把兩邊所有欄位都撈回來逐一比對」的檢查。

---

## 使用方式

```bash
python sync_actest.py                      # 全部資料表，實際寫入
python sync_actest.py --dry-run            # 只比對差異，不寫入
python sync_actest.py --tables INVMA,PURTG # 指定資料表
python sync_actest.py --no-delete          # 保留 target 多出來的列
python sync_actest.py --schema-only        # 只建表 / 補欄位
python sync_actest.py --no-verify          # 跳過事後驗證
```

Exit code：0 = 全部成功，1 = 任一資料表失敗（可供排程器判斷）。

**排程：** Windows 工作排程器指向 `run_sync.bat`，起始位置設為本目錄。

---

## 擴充到其他資料表 / 其他伺服器

程式完全由 schema 驅動，沒有寫死任何欄位名。要換表或換庫只要改 `sync_config.json`：

```json
{
  "source": {"server": "...", "port": 1433, "user": "...", "password": "...", "database": "..."},
  "target": {"server": "...", "port": 8001, "user": "...", "password": "...", "database": "..."},
  "tables": ["TABLE_A", "TABLE_B"]
}
```

**前提條件：** 每張表都必須有主鍵（差異比對的依據）。沒有 PK 的表會直接報錯。

**目前未處理：** identity 欄位（來源這六張表都沒有）、外鍵、非 PK 索引、trigger、
computed 欄位（會自動排除不寫入）。這些若需要一併同步要另外擴充。

**密碼：** 設定檔內為明碼（沿用本 repo 既有慣例）。可用環境變數覆蓋：
`ACTEST_SRC_PWD`、`ACTEST_TGT_PWD`。
