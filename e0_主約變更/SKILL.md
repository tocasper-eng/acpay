# SKILL: pos_log 主約變更追蹤

## 適用場景

當需要修改或擴充 pos_log 變更追蹤機制時使用此技能。

## 核心知識

### 資料流

```
pos (主約) ──[tr_110]──> pos_log (變更記錄) ──[tr_010]──> pos_log_detail (欄位差異)
```

1. 使用者建立 `pos_log` 並填入 `契約編號`
2. `tr_110` 自動從 `pos` 複製所有欄位到 `pos_log`
3. 使用者修改 `pos_log` 中的欄位
4. `tr_010` 自動比對 `pos_log` 與 `pos`，將差異寫入 `pos_log_detail`

### 新增欄位的步驟

當 `pos` 和 `pos_log` 新增欄位時，需同步更新以下三支 trigger：

1. **tr_110_pos_log_from_pos.sql** — 在 `UPDATE pos_log SET` 區段加入新欄位的複製
2. **tr_010_pos_log_to_pos_log_pos_log_detail.sql** — 在 `CROSS APPLY (VALUES ...)` 區段加入新欄位的比對
3. 重新部署到資料庫（先 DROP 再 CREATE）

### 部署順序

```
1. tb_pos_log_detail_主約變更內容.sql   (建表)
2. tr_010_pos_log_to_pos_log_pos_log_detail.sql  (差異追蹤 trigger)
3. tr_100_pos_log_00.sql               (menuflag trigger)
4. tr_110_pos_log_from_pos.sql         (從 pos 帶入 trigger)
```

### 注意事項

- `tr_010` 的 sequence 010 確保它在 tr_110 (sequence 110) 之前執行
- `tr_010` 遇到 `UPDATE(契約編號)` 時會 RETURN，避免與 tr_110 衝突
- `pos_log_detail` 的 UNIQUE INDEX `(menuflag, fieldname)` 確保每個欄位只有一筆差異記錄
- `tr_010` 使用 DELETE + re-INSERT 策略，每次 UPDATE 都重新計算所有欄位差異
- 欄位值統一 CAST 為 `nvarchar(max)` 存入 oldvalue / newvalue
- NULL 值以 `ISNULL(value, '')` 處理，確保 NULL vs NULL 不被視為差異
