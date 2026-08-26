# SQL Server 跨伺服器資料表同步

把 source SQL Server 的指定資料表，每次執行時重新比對後**單向**寫入 target。

| 端 | 伺服器 | 資料庫 |
|----|--------|--------|
| source | `192.168.50.7` | `AC` |
| target | `192.168.50.53,8001` | `ac` |

資料表：`INVMA` `INVMB` `PURTG` `PURTH` `PURTI` `PURTJ`（共 880 列）

> 程式與特定資料庫無關，同步對象一律由 `sync_config.json` 決定。

## 快速開始

```bash
pip install pymssql
python sync_db.py --dry-run   # 先看差異
python sync_db.py             # 實際同步
```

## 檔案

| 檔案 | 用途 |
|------|------|
| `sync_db.py` | 主程式 |
| `sync_config.json` | 連線設定、資料表清單、行為選項 |
| `run_sync.bat` | Windows 工作排程器啟動檔 |
| `SKILL.md` | 設計說明、驗證紀錄、踩坑經驗 |
| `logs/` | 每日執行紀錄（不進版控） |

## 行為

- target 沒有的資料表會依 source 定義自動建立（含 PK、DEFAULT）
- **target 字元欄位一律建成 `Chinese_Taiwan_Stroke_CI_AS`**（`options.target_collation`）；
  寫入前會檢查 source 主鍵在此定序下是否會撞鍵，有衝突就中止該表
- 既有 target 表定序不符時會拒絕執行，需加 `--rebuild` 重建（只動 target）
- 以主鍵 + SHA2_256 逐列比對，只寫入真正有異動的列
- source 沒有的列會從 target 刪除（`--no-delete` 可保留）
- 每張表獨立 transaction，失敗整批 rollback 且不影響其他表
- 同步後自動再比對一次驗證

## 換同步目標

改 `sync_config.json` 的 `source` / `target` / `tables` 即可，程式不用動。
要同時維護多組同步就複製設定檔，用 `python sync_db.py --config other.json` 指定。

詳細設計與參數說明見 [SKILL.md](SKILL.md)。
