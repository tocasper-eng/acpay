# SKILL.md — ERD HTML 產生標準作業流程

## 適用場景

使用者提供：
- 目標資料庫連線資訊
- 資料表清單及邏輯 FK 定義
- 輸出格式 (HTML)

## 標準步驟

### Step 1：查詢資料表 Schema

使用 MCP 工具 `mcp__sqlserver-nutc__query` 查詢 `INFORMATION_SCHEMA.COLUMNS`：

```sql
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE,
       COLUMNPROPERTY(OBJECT_ID(TABLE_NAME), COLUMN_NAME, 'IsIdentity') as IsIdentity
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('表名清單')
ORDER BY TABLE_NAME, ORDINAL_POSITION
```

### Step 2：查詢 Primary Key

```sql
SELECT t.name AS TABLE_NAME, c.name AS COLUMN_NAME, ic.key_ordinal
FROM sys.indexes i
JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
JOIN sys.tables t ON i.object_id = t.object_id
WHERE i.is_primary_key = 1 AND t.name IN ('表名清單')
ORDER BY t.name, ic.key_ordinal
```

### Step 3：產生 HTML ERD

HTML 結構包含三個區塊：

1. **ERD Canvas** — 使用絕對定位的 table card + SVG 關聯線
   - 每張表一個 card，顯示 PK/FK 和關鍵業務欄位
   - SVG overlay 繪製 Bezier curve 連接線 + crow's foot 標記
   - 滑鼠 hover 時高亮相關表、淡化無關表
   - 色彩分群：組織(藍)、主檔(橘)、交易(綠)、追蹤(紫)

2. **Relationships Table** — 完整 FK 關聯定義，含子表/父表/說明

3. **Detail Cards** — 每張表的完整欄位清單，標註 PK/FK/Identity

### Step 4：JavaScript 互動

- DOM loaded 後計算 card 位置，繪製 SVG 連接線
- 連接線使用 Bezier curve，父端圓點、子端 crow's foot
- Hover 時 opacity 淡化無關 card

### Step 5：更新文件並推送

1. 更新 `CLAUDE.md` — 記錄涵蓋的表、關聯定義
2. 更新 `SKILL.md` — 記錄操作流程
3. Git commit & push 至指定 GitHub repo

## 版面配置建議

```
左側：組織階層 (comp → plant → ware → posi)，由上至下
中央：主檔 + 追蹤 (item, itio, mes_itio)
右側：交易 (trh→trd, toh→tod, tdh→tdd)，三組並排
```

## 踩坑紀錄

| 問題 | 解法 |
|------|------|
| eep_posi FK 定義寫 `compno` 但實際欄位是 `wareno` | 以實際 schema 為準，FK 改為 wareno → eep_ware.wareno |
| eep_Tod 大小寫不一致 (SQL Server CI 定序) | 資料庫回傳 `eep_Tod`，HTML 中統一顯示為小寫 `eep_tod` |
| `itemna` 欄名結尾有空白 | 8081 伺服器的 `itemna ` 含尾端空白，查詢時注意 |
| SVG 線條被 card 遮擋 | SVG z-index: 1，card z-index: 2，hover 時 card 提升為 3 |
