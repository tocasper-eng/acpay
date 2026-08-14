# CLAUDE.md — ACPAY ERD 資料表關聯圖

## 專案概述

本專案產出 ACPAY 資料庫的互動式 ERD 關聯圖 (HTML)，以 TBLDEF 定義的資料表關聯為基礎，搭配 COLDEF 的中文欄位名稱。

## 資料來源

| 項目 | 說明 |
|------|------|
| 資料庫 | `acpay @ 163.17.141.61,8081` |
| 關聯定義 | `TBLDEF` 表 — 38 筆關聯（33 筆 T 型 FK + 5 筆 G 型 trigger chain） |
| 中文欄位抬頭 | `COLDEF` 表 — `TABLE_NAME`, `FIELD_NAME`, `CAPTION` |
| MCP 工具 | `mcp__sqlserver-nutc__query`（需指定 `db=acpay`，預設連 master） |

## TBLDEF 結構

| 欄位 | 說明 |
|------|------|
| `dbname` | 資料庫名稱 (acpay) |
| `systno` | 子系統代碼 (WMS, HR, CS, IS, ORG, AR) |
| `menunum` | 功能代碼 (3 碼，如 62K, A01) |
| `childTable` | 子資料表名稱 |
| `childTableDesc` | 子表中文說明 |
| `childkeys` | FK 鍵值欄位（可為複合鍵，逗號分隔） |
| `hasparent` | 是否有父階 (Y/N) |
| `reltype` | 關聯類型：T = FK 關聯, G = trigger chain |
| `parentTable` | 主資料表名稱 |
| `parentTableDesc` | 主表中文說明 |
| `parentkeys` | 主表對應鍵值 |

## G 型關聯（trigger chain）

reltype='G' 表示 trigger chain 關聯，結構與 T 型不同：

| TBLDEF 欄位 | G 型語意 | 範例 |
|-------------|----------|------|
| `childTable` | trigger 名稱 | `tr_011_eep_trd_mes_itio` |
| `childTableDesc` | trigger 說明 | `繳料異動` |
| `childkeys` | 來源資料表 | `eep_trd` |
| `parentTable` | 目標資料表 | `mes_itio` |
| `parentkeys` | 目標 trigger | `tr_mes_itio_sync` |

ERD 中 G 型以虛線 + 箭頭 + trigger 名稱標籤呈現，與 T 型的實線 + crow's foot 區分。

### 現有 G 型關聯 (5 筆)

| systno | menunum | trigger | 來源表 | 目標表 |
|--------|---------|---------|--------|--------|
| WMS | 62K | tr_011_eep_trd_mes_itio | eep_trd | mes_itio |
| WMS | 62J | tr_011_eep_tod_mes_itio | eep_tod | mes_itio |
| WMS | 66D | tr_011_eep_tdd_mes_itio | eep_tdd | mes_itio |
| WMS | B01 | tr_011_pos_tod_mes_itio | pos_tod | mes_itio |
| WMS | 67Q | tr_mes_itio_level | mes_itio | mes_level |

## 子系統 (6 組)

| systno | 名稱 | 模組數 |
|--------|------|--------|
| WMS | 倉儲管理 | 7 |
| ORG | 組織架構 | 4 |
| HR | 人力資源 | 1 |
| CS | 客戶服務 | 6 |
| IS | 資訊系統 | 4 |
| AR | 應收帳款 | 2 |

## 功能模組 (24 組)

| systno | menunum | 名稱 | 資料表 | FK 鍵值 |
|--------|---------|------|--------|---------|
| WMS | 62J | 一盤領用 | eep_tod → eep_toh; 🔗 eep_tod →G mes_itio | tono |
| WMS | 62K | 一盤繳庫 | eep_trd → eep_trh, eep_plant → eep_comp; 🔗 eep_trd →G mes_itio | trno, compno |
| WMS | 66D | 庫存調撥 | eep_tdd → eep_tdh; 🔗 eep_tdd →G mes_itio | tdno |
| WMS | 67Q | 庫存異動查詢 | mes_itio → eep_item, mes_itio → eep_ware; 🔗 mes_itio →G mes_level | itemno, wareno |
| WMS | 96A | 倉庫儲位設定 | eep_ware → eep_plant, eep_ware_empl → eep_ware, eep_posi → eep_ware | plantno, wareno |
| WMS | 96D | 物料主檔 | eep_item → eep_clas | clasno |
| WMS | B01 | 施工異動 | 🔗 pos_tod →G mes_itio | — |
| ORG | 91A | 部門代碼 | eep_depa → eep_comp, eep_depa → eep_group2 | compno, group2 |
| ORG | 94P | 銷售群組 | eep_sdgrp → eep_sdorg | sdorg |
| ORG | 95H | 工廠公司 | eep_plant → eep_comp | compno |
| ORG | 95P | 採購群組 | eep_mmgrp → eep_mmorg | mmorg |
| HR | 93A | 員工主檔 | eep_empl → eep_depa, eep_empl → eep_line | depano, linenum |
| CS | A01 | 客服通知 | eep_iwd_10 → eep_iwh, eep_iwd_20 → eep_iwh | 契約編號 |
| CS | B01 | 外派工單 | pos_tod → eep_iwh | 契約編號 |
| CS | C01 | 新案建檔 | pos_tod → eep_pos | 契約編號 |
| CS | D01 | 連鎖客戶 | eep_d01 → pos | 連鎖性客戶編號 |
| CS | E01 | 主約變更 | pos_tod → pos_log | 契約編號 |
| CS | F01 | 解約建檔 | pos_tod → eep_dac | 契約編號 |
| IS | 61A | 商品組合 | eep_bmd → eep_bmh, 系統別 → eep_bmh | bmno, 系統別代號 |
| IS | 91H | 選單欄位定義 | eep_numh → eep_menu | menunum |
| IS | 91I | 欄位片語內容 | eep_num8 → eep_numh | menunum,fieldno |
| IS | 99B | 用戶群組 | usergroups → users, usergroups → groups | userid, groupid |
| AR | 48E | 結帳單 | vw_POS_CRM_ACRTB → vw_POS_CRM_ACRTA | TB001,TB002 |
| AR | 48F | 收款單 | vw_POS_CRM_ACRTD → vw_POS_CRM_ACRTC | TD001,TD002 |

## 涵蓋資料表 (45 張)

eep_bmd, eep_bmh, eep_clas, eep_comp, eep_d01, eep_dac, eep_depa, eep_empl, eep_group2, eep_item, eep_iwd_10, eep_iwd_20, eep_iwh, eep_line, eep_menu, eep_mmgrp, eep_mmorg, eep_num8, eep_numh, eep_plant, eep_pos, eep_posi, eep_sdgrp, eep_sdorg, eep_tdd, eep_tdh, eep_tod, eep_toh, eep_trd, eep_trh, eep_ware, eep_ware_empl, groups, mes_itio, mes_level, pos, pos_log, pos_tod, usergroups, users, vw_POS_CRM_ACRTA, vw_POS_CRM_ACRTB, vw_POS_CRM_ACRTC, vw_POS_CRM_ACRTD, 系統別

> 含 5 個 trigger（childTable 為 trigger 名稱，不計入資料表數）

## HTML 架構

| 區域 | 說明 |
|------|------|
| 左側導航欄 | 三層結構：dbname → systno → menunum，可折疊展開 |
| 右側主畫布 | 動態渲染該 menunum 的 table card + SVG 關聯線 |
| 頂部欄位 | 顯示 systno breadcrumb + menunum 名稱 + 統計資訊 |
| Table Card | 表頭顯示表名+中文說明，欄位列顯示 COLDEF 資料 |
| FK 標示 | 金色底色 + 鑰匙圖示 |
| T 型關聯線 | SVG Bezier 曲線 + crow's foot (多端) + circle (一端)，實線 |
| G 型關聯線 | SVG Bezier 曲線 + 箭頭，虛線 + trigger 名稱標籤 |
| Hover | 滑過關聯線高亮兩端 table card |
| 拖曳 | Table card 可自由拖曳調整位置 |
| 底部資訊列 | 38 筆關聯 · 45 張表 · 24 模組 · 6 子系統 |

## 注意事項

- COLDEF 查詢需指定 `db=acpay`，MCP 預設連 master 會報 Invalid object name
- eep_tod/eep_toh 的 COLDEF 有大小寫重複 (eep_tod vs eep_Tod)，已手動合併
- eep_dac、pos_tod、系統別 無 COLDEF 資料，使用 INFORMATION_SCHEMA 欄位名
- mes_level 無 COLDEF 資料，使用 INFORMATION_SCHEMA 欄位 (compno, plantno, wareno, posino)
- eep_ware_empl、eep_mmgrp、eep_mmorg 資料表尚未建立，ERD 顯示預設欄位結構
- B01 同時出現在 CS（FK: pos_tod → eep_iwh）和 WMS（G 型: pos_tod →G mes_itio）
- da_TBLDEF.sql 中 WMS/B01 的 G 型 childkeys 為 `pos_tdd`（可能為筆誤），ERD 中修正為 `pos_tod`
- FK 鍵值可能是中文欄位名 (契約編號, 連鎖性客戶編號)
- COLDEF CAPTION 有時帶尾碼字母 (契約編號F, 連鎖性客戶編號Y)，FK 匹配時需去尾碼
- FK 鍵名可能是欄位前綴 (sdorg → sdorgno)，匹配時用 startsWith 比對
- A01 中 eep_iwd_10 出現兩次 (服務內容、補充說明)，為同一 FK，ERD 去重顯示
- users/groups/usergroups 表欄位名為大寫 (USERID, GROUPID)，isKeyCol 需忽略大小寫
