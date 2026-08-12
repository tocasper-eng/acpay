# CLAUDE.md — ACPAY ERD 資料表關聯圖

## 專案概述

本專案產出 ACPAY 資料庫的互動式 ERD 關聯圖 (HTML)，以 TBLDEF 定義的資料表關聯為基礎，搭配 COLDEF 的中文欄位名稱。

## 資料來源

| 項目 | 說明 |
|------|------|
| 資料庫 | `acpay @ 163.17.141.61,8081` |
| 關聯定義 | `TBLDEF` 表 — 18 筆 parent-child 關聯 |
| 中文欄位抬頭 | `COLDEF` 表 — `TABLE_NAME`, `FIELD_NAME`, `CAPTION` |
| MCP 工具 | `mcp__sqlserver-nutc__query`（需指定 `db=acpay`，預設連 master） |

## TBLDEF 結構

| 欄位 | 說明 |
|------|------|
| `menunum` | 功能代碼 (3 碼，如 62K, A01) |
| `childTable` | 子資料表名稱 |
| `childTableDesc` | 子表中文說明 |
| `childkeys` | FK 鍵值欄位（可為複合鍵，逗號分隔） |
| `hasparent` | 是否有父階 (Y/N) |
| `parentTable` | 主資料表名稱 |
| `parentTableDesc` | 主表中文說明 |
| `parentkeys` | 主表對應鍵值 |

## 功能模組 (13 組)

| menunum | 名稱 | 資料表 | FK 鍵值 |
|---------|------|--------|---------|
| 62J | 一盤領用 | eep_tod → eep_toh | tono |
| 62K | 一盤繳庫 | eep_trd → eep_trh, eep_plant → eep_comp | trno, compno |
| 66D | 庫存調撥 | eep_tdd → eep_tdh | tdno |
| 67Q | 庫存異動查詢 | mes_itio → eep_item, mes_itio → eep_ware | itemno, wareno |
| 91H | 選單欄位定義 | eep_numh → eep_menu | menunum |
| 91I | 欄位片語內容 | eep_num8 → eep_numh | menunum,fieldno |
| 96A | 倉庫儲位設定 | eep_ware → eep_plant, eep_posi → eep_ware | plantno, wareno |
| A01 | 客服通知 | eep_iwd_10 → eep_iwh, eep_iwd_20 → eep_iwh | 契約編號 |
| B01 | 外派工單 | pos_tod → eep_iwh | 契約編號 |
| C01 | 新案建檔 | pos_tod → eep_pos | 契約編號 |
| D01 | 連鎖客戶 | eep_d01 → pos | 連鎖性客戶編號 |
| E01 | 主約變更 | pos_tod → pos_log | 契約編號 |
| F01 | 解約建檔 | pos_tod → eep_dac | 契約編號 |

## 涵蓋資料表 (24 張)

eep_comp, eep_d01, eep_dac, eep_item, eep_iwd_10, eep_iwd_20, eep_iwh, eep_menu, eep_num8, eep_numh, eep_plant, eep_pos, eep_posi, eep_tdd, eep_tdh, eep_tod, eep_toh, eep_trd, eep_trh, eep_ware, mes_itio, pos, pos_log, pos_tod

## HTML 架構

| 區域 | 說明 |
|------|------|
| 左側導航欄 | 13 個 menunum 項目，點擊切換 ERD |
| 右側主畫布 | 動態渲染該 menunum 的 table card + SVG 關聯線 |
| Table Card | 表頭顯示表名+中文說明，欄位列顯示 COLDEF 資料 |
| FK 標示 | 金色底色 + 🔑 圖示 |
| 關聯線 | SVG Bezier 曲線 + crow's foot (多端) + circle (一端) |
| Hover | 滑過關聯線高亮兩端 table card |

## 注意事項

- COLDEF 查詢需指定 `db=acpay`，MCP 預設連 master 會報 Invalid object name
- eep_tod/eep_toh 的 COLDEF 有大小寫重複 (eep_tod vs eep_Tod)，已手動合併
- eep_dac、pos_tod 無 COLDEF 資料，使用 INFORMATION_SCHEMA 欄位名
- FK 鍵值可能是中文欄位名 (契約編號, 連鎖性客戶編號)
- COLDEF CAPTION 有時帶尾碼字母 (契約編號F, 連鎖性客戶編號Y)，FK 匹配時需去尾碼
- A01 中 eep_iwd_10 出現兩次 (服務內容、補充說明)，為同一 FK，ERD 去重顯示
