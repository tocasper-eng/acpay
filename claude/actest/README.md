# actest 資料表同步

把 source SQL Server 的指定資料表，每次執行時重新比對後**單向**寫入 target。

| 端 | 伺服器 | 資料庫 |
|----|--------|--------|
| source | `192.168.50.7` | `ACTest` |
| target | `192.168.50.53,8001` | `actest` |

資料表：`INVMA` `INVMB` `PURTG` `PURTH` `PURTI` `PURTJ`

## 快速開始

```bash
pip install pymssql
python sync_actest.py --dry-run   # 先看差異
python sync_actest.py             # 實際同步
```

## 檔案

| 檔案 | 用途 |
|------|------|
| `sync_actest.py` | 主程式 |
| `sync_config.json` | 連線設定、資料表清單、行為選項 |
| `run_sync.bat` | Windows 工作排程器啟動檔 |
| `SKILL.md` | 設計說明、驗證紀錄、踩坑經驗 |
| `logs/` | 每日執行紀錄（不進版控） |

## 行為

- target 沒有的資料表會依 source 定義自動建立（含 PK、collation、DEFAULT）
- 以主鍵 + SHA2_256 逐列比對，只寫入真正有異動的列
- source 沒有的列會從 target 刪除（`--no-delete` 可保留）
- 每張表獨立 transaction，失敗整批 rollback 且不影響其他表
- 同步後自動再比對一次驗證

詳細設計與參數說明見 [SKILL.md](SKILL.md)。
