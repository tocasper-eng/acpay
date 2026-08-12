# SKILL.md — ERD 關聯圖建置標準流程

## 適用場景

從 TBLDEF + COLDEF 產生互動式 ERD HTML。

## 標準步驟

### Step 1：查詢 TBLDEF 關聯定義

```sql
-- MCP 查詢必須指定 db=acpay
SELECT menunum, childTable, childTableDesc, childkeys,
       hasparent, parentTable, parentTableDesc, parentkeys
FROM TBLDEF ORDER BY menunum, num
```

### Step 2：查詢 COLDEF 中文欄位抬頭

```sql
SELECT TABLE_NAME, FIELD_NAME, CAPTION
FROM COLDEF
WHERE TABLE_NAME IN ('eep_trd','eep_trh',...)
ORDER BY TABLE_NAME, SEQ
```

**注意：**
- 單次查詢不可超過 ~10 張表，否則 MCP 回傳超限，分批查詢
- eep_tod 有大小寫重複 (`eep_tod` + `eep_Tod`)，需手動合併
- eep_toh 的 COLDEF 使用 tr* 欄位名 (trtype, trno2)，實際欄位為 to*

### Step 3：補查無 COLDEF 資料的表

```sql
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('eep_dac','pos_tod')
ORDER BY TABLE_NAME, ORDINAL_POSITION
```

對於中文欄位名的表 (eep_dac)，caption = 欄位名。

### Step 4：產生 HTML

架構：
1. 左側導航欄：TBLDEF 的 distinct menunum
2. 右側畫布：動態渲染 table card + SVG 關聯線
3. 資料全部嵌入 JavaScript (TBLDEF array + COLDEF object)

關鍵設計：
- 審計欄位不顯示 (flowflag, menuflag, chjernoi~chjernoz)
- FK 欄位金色標示 + 🔑 圖示
- 卡片最多顯示 22 欄，超過顯示 "... 還有 N 個欄位"
- 動態佈局：pure parent 左欄、middle 中欄、pure child 右欄
- SVG Bezier + crow's foot 標記

### Step 5：更新文件 + Git

```bash
# 更新 CLAUDE.md 和 SKILL.md
# Commit
git add claude/erd/erd_wms.html claude/erd/CLAUDE.md claude/erd/SKILL.md
git commit -m "feat(erd): 更新 ERD 內容"
# Push 到指定 remote
git push gemio_wms_erd main
```

## 踩坑紀錄

| 問題 | 解法 |
|------|------|
| MCP 預設連 master DB | 查詢加 `db=acpay` 參數 |
| COLDEF 查太多表回傳超限 | 分 2~3 批查詢，每批 6~8 張表 |
| eep_tod COLDEF 大小寫重複 | 合併 eep_tod + eep_Tod，取中文 caption |
| eep_toh 欄位名 tr* 非實際 | COLDEF 顯示用，實際 DB 欄位為 to* |
| FK 鍵值為中文欄位名 | 匹配時同時比對 FIELD_NAME 和 CAPTION |
| CAPTION 尾碼字母 (契約編號F) | 去尾碼字母後再匹配 FK |
| A01 同一 FK 出現兩次 | 以 child→parent 為 key 去重 |
| eep_dac/pos_tod 無 COLDEF | 用 INFORMATION_SCHEMA 補欄位 |
| eep_menu.menunum 格式不同 | TBLDEF menunum (3碼) 與 eep_menu (長格式) 不匹配 |
