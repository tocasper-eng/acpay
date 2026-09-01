# CLAUDE.md — 跨伺服器資料表單向同步

## Mission

把 source SQL Server 的指定資料表，**每次執行都重新比對**後單向寫入 target。
source 永遠不會被寫入。程式完全由 schema 驅動，沒有寫死任何欄位名或資料表名。

## 資料庫

同步對象一律由 `sync_config.json` 決定，**不要在程式裡寫死**。目前設定：

| 端 | server | database | 帳密 | 版本 / 定序 |
|----|--------|----------|------|-------------|
| source | `192.168.50.7`（預設 1433） | **`AC`** | `drlee` / `ACpos#1234` | SQL 2022 / `Chinese_Taiwan_Stroke_BIN` |
| target | `192.168.50.53,8001` | `ac` | `drlee` / `ACpos#1234` | SQL 2025 / `Chinese_Taiwan_Stroke_CI_AS` |

> **192.168.50.7 的伺服器層級定序是 BIN（區分大小寫），資料庫名大小寫必須完全正確。**
> 這台上 `AC` / `ACT` / `ACTest` 是三個不同的資料庫。連到不存在的庫名會回報
> `18456 登入失敗`（不是「找不到資料庫」），極易誤判成帳密錯。先連 `master`
> 查 `sys.databases` 確認。

> `192.168.50.53,8001` 與 `,8000` 是**不同 instance**。8001 上有 `ac`（正式同步目標）
> 與 `actest`（舊測試目標，可當 scratch 用）。

**同步的資料表（880 列）：**

| 表 | 欄位 | PK | 列數 |
|----|------|-----|------|
| `INVMA` | 21 | MA001, MA002 | 3 |
| `INVMB` | 176 | MB001 | 150 |
| `PURTG` | 65 | TG001, TG002 | 300 |
| `PURTH` | 79 | TH001, TH002, TH003 | 415 |
| `PURTI` | 59 | TI001, TI002 | 6 |
| `PURTJ` | 53 | TJ001, TJ002, TJ003 | 6 |

六張表都**沒有** identity / computed 欄位；型別只有 `int` / `nchar` / `nvarchar` / `numeric`；
共 350 個欄位帶 DEFAULT 條件約束。

## 檔案

| 檔案 | 用途 |
|------|------|
| `sync_db.py` | 主程式（唯一的程式碼） |
| `sync_config.json` | 連線、資料表清單、行為選項 |
| `run_sync.bat` | Windows 工作排程器啟動檔（用 `%~dp0`，可搬移） |
| `SKILL.md` | 完成任務紀錄、設計決策、踩坑、驗證結果 |
| `README.md` | 對外簡介 |
| `README_task.md` | 任務書（使用者提供的原始需求） |
| `logs/` | 每日執行紀錄（`.gitignore`，不進版控） |

## 演算法

```
1. 讀 source schema（sys.columns + PK）
2. 主鍵衝突檢查（target 定序比 source 寬鬆時）
3. target 沒有該表就照 source 建（含 PK、collation、DEFAULT）
4. 兩邊各跑 SELECT <PK>, HASHBYTES('SHA2_256', 全欄位串接) → {pk: hash}
5. source有/target無→INSERT；hash不同→UPDATE；target有/source無→DELETE
6. 只把有異動的 PK 從 source 撈完整列寫入（每表獨立 transaction，失敗 rollback）
7. 再算一次 hash 比對，確認差異為 0
```

用 hash 而非整表拉回來比：176 欄的表全量傳兩份太貴，只傳 `(PK, 64字元hash)`，
有異動的列才撈完整內容，表變大成本不會爆掉。

## 設定選項（sync_config.json → options）

| 選項 | 目前值 | 說明 |
|------|--------|------|
| `target_collation` | `"Chinese_Taiwan_Stroke_CI_AS"` | target 字元欄位定序；`null` = 沿用 source |
| `create_missing_tables` | `true` | target 缺表時自動依 source 建立 |
| `add_missing_columns` | `true` | target 缺欄位時 ALTER ADD（一律建成 NULL 允許） |
| `delete_extra_rows` | `true` | 刪除 target 多出來的列 |
| `batch_size` | `500` | 批次筆數 |
| `verify_after_sync` | `true` | 同步後再比對一次 |

## 定序政策

**source 資料進入 target 時，定序一律 `Chinese_Taiwan_Stroke_CI_AS`。**

CI_AS 比 source 的 BIN 寬鬆 —— **不分大小寫、不分全半形、不分平假名片假名**。
所以 source 兩筆不同的主鍵可能在 target 撞成一筆：

| source 兩筆鍵 | BIN | CI_AS |
|---------------|-----|-------|
| `'abc'` / `'ABC'` | 不同 | **相同** |
| `'ｄｅｆ'` / `'def'` | 不同 | **相同** |
| `'ﾊ'` / `'は'` | 不同 | **相同** |

`check_key_collisions()` 在每張表寫入前，於 source 上用 **target 的定序** `GROUP BY` 主鍵，
讓 SQL Server 自己判斷等價性（不要在 Python 端模擬定序規則）。有衝突就列出並中止該表。

> AC 六張表目前 0 組衝突，但這是**資料相依**的結論，不是永久保證。
> 檢查必須留在每次執行的流程裡。

改了 `target_collation` 後，既有 target 表定序還是舊的，程式會**拒絕執行**並要求 `--rebuild`
（`ALTER COLUMN` 改定序需先拆 PK 與相依索引；鏡像直接 DROP + CREATE 更單純）。

## 指令

```bash
python sync_db.py                      # 全部資料表，實際寫入（日常用這個）
python sync_db.py --dry-run            # 只比對差異，不寫入
python sync_db.py --tables INVMA,PURTG # 指定資料表
python sync_db.py --no-delete          # 保留 target 多出來的列
python sync_db.py --schema-only        # 只建表 / 補欄位
python sync_db.py --rebuild            # 定序不符時 DROP 重建該表並重灌
python sync_db.py --no-verify          # 跳過事後驗證
python sync_db.py --config other.json  # 另一組同步設定
```

Exit code：0 = 全部成功，1 = 任一資料表失敗（供排程器判斷）。
單一資料表失敗會被隔離，其餘照常同步。

## 修改本模組時要注意

- **前提：每張表都要有主鍵。** 沒有 PK 的表直接報錯，差異比對無從做起。
- **hash 表示式改動要特別小心。** 每個欄位都必須明確 `CONVERT`
  （`numeric`→`nvarchar(50)`、`float`→ style 3、日期→ style 126、binary→ style 2 hex），
  否則不同 SQL 版本的隱含轉換格式可能不同，導致「每次執行都更新同一批列」的假異動。
  NULL 哨符 `NCHAR(1)`、欄位分隔 `NCHAR(2)` 不可省 —— 沒有分隔符時
  `('a','bc')` 與 `('ab','c')` 會 hash 相同。
- **定序名會直接串進 SQL**（`COLLATE` 不吃參數），載入設定時已用正規式擋非法字元，
  新增類似的 SQL 串接時要比照辦理。
- **`sys.columns.max_length` 對 `nchar`/`nvarchar` 是位元組數**，要 `// 2` 才是字元數
  （`max_length=2` 是 `nchar(1)`）；`char`/`varchar`/`binary` 直接用，`-1` 代表 `max`。
- **未處理：** identity 欄位、外鍵、非 PK 索引、trigger。computed 欄位會自動排除不寫入。

## 驗證要求

改動程式後，**這三項缺一不可**：

1. **冪等性** —— 連跑兩次，第二次差異必須是 0。這是唯一能抓出
   「hash 在兩台機器格式化不一致」的手段。
2. **三條修復路徑** —— 分別竄改 / 刪除 / 插入假列到 target，確認各自被偵測並修復。
3. **獨立逐欄逐列比對** —— 用另一段程式把兩邊所有欄位撈回來比對。
   只用程式自己的 hash 驗證等於自我背書；hash 若漏掉某欄，兩邊都會漏、驗證照樣通過。

獨立比對腳本見 `SKILL.md`。

## 連線

一律用 pymssql 直連目標伺服器，**不要用 MCP 工具查 schema**（可能連到不同伺服器）。

```python
import pymssql
src = pymssql.connect(server='192.168.50.7', user='drlee', password='ACpos#1234',
                      database='AC', charset='utf8')
tgt = pymssql.connect(server='192.168.50.53', port=8001, user='drlee', password='ACpos#1234',
                      database='ac', charset='utf8')
```

Windows 下 Python stdout 要設 utf-8，否則中文亂碼：
`sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')`
（注意：`sync_db.py` 匯入時已自行包裝 stdout，寫測試腳本 import 它時不要重複包裝。）

密碼可用環境變數覆蓋：`DBSYNC_SRC_PWD`、`DBSYNC_TGT_PWD`。
