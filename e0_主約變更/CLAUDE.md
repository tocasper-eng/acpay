# e0_主約變更 — pos_log 欄位變更追蹤

## 功能說明

當 `pos_log` 的欄位內容與原始 `pos` 資料不同時，自動記錄差異到 `pos_log_detail`。

## 資料庫

- **Server:** 163.17.141.61,8000
- **Database:** acpay

## 相關資料表

| 資料表 | 用途 |
|--------|------|
| `pos` | 主約（原始契約資料） |
| `pos_log` | 主約變更記錄（從 pos 帶入後可修改） |
| `pos_log_detail` | 欄位層級的變更明細（fieldname / oldvalue / newvalue） |

## Trigger 執行順序 (on pos_log)

| 順序 | Trigger | 事件 | 說明 |
|------|---------|------|------|
| 010 | `tr_010_pos_log_to_pos_log_pos_log_detail` | AFTER UPDATE | 比對 pos_log 與 pos 的 76 個欄位，差異寫入 pos_log_detail |
| 100 | `tr_100_pos_log` | AFTER INSERT | 設定 menuflag |
| 110 | `tr_110_pos_log_from_pos` | AFTER INSERT, UPDATE | 當契約編號異動時，從 pos 帶入所有欄位 |

## tr_010 邏輯

1. 若 `UPDATE(契約編號)` → 跳過（tr_110 會覆寫所有欄位）
2. 刪除該 pos_log 記錄原有的 `pos_log_detail` 明細
3. 用 `CROSS APPLY (VALUES ...)` 逐欄比對 `pos_log` vs `pos`
4. `ISNULL(pos_log值, '') <> ISNULL(pos值, '')` 的欄位寫入 `pos_log_detail`
5. oldvalue = pos 原始值，newvalue = pos_log 修改後的值

## 檔案清單

| 檔案 | 類型 | 說明 |
|------|------|------|
| `tb_pos_log_主約變更.sql` | Table | pos_log 表定義 |
| `tb_pos_log_detail_主約變更內容.sql` | Table | pos_log_detail 表定義 |
| `tr_010_pos_log_to_pos_log_pos_log_detail.sql` | Trigger | 欄位差異追蹤 |
| `tr_100_pos_log_00.sql` | Trigger | menuflag 設定 |
| `tr_110_pos_log_from_pos.sql` | Trigger | 從 pos 帶入欄位 |
| `ep_pos_log_00_存後.sql` | Procedure | 存後事件程序 |

## GitHub

- **Repo:** [tocasper-eng/acpay_pos_log](https://github.com/tocasper-eng/acpay_pos_log)