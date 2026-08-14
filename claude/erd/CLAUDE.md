# CLAUDE.md — ACPAY ERD 資料表關聯圖

## 專案概述

本專案產出 ACPAY 資料庫的互動式 ERD 關聯圖 (HTML)，以 TBLDEF 定義的資料表關聯為基礎，搭配 COLDEF 的中文欄位名稱。

## 資料來源

| 項目 | 說明 |
|------|------|
| 資料庫 | `acpay @ 163.17.141.61,8081` |
| 關聯定義 | `TBLDEF` 表 — 33 筆 parent-child 關聯 |
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
| `reltype` | 關聯類型 (T) |
| `parentTable` | 主資料表名稱 |
| `parentTableDesc` | 主表中文說明 |
| `parentkeys` | 主表對應鍵值 |

## 子系統 (6 組)

| systno | 名稱 | 模組數 |
|--------|------|--------|
| WMS | 倉儲管理 | 6 |
| ORG | 組織架構 | 4 |
| HR | 人力資源 | 1 |
| CS | 客戶服務 | 6 |
| IS | 資訊系統 | 4 |
| AR | 應收帳款 | 2 |

## 功能模組 (23 組)

| systno | menunum | 名稱 | 資料表 | FK 鍵值 |
|--------|---------|------|--------|---------|
| WMS | 62J | 一盤領用 | eep_tod → eep_toh | tono |
| WMS | 62K | 一盤繳庫 | eep_trd → eep_trh, eep_plant → eep_comp | trno, compno |
| WMS | 66D | 庫存調撥 | eep_tdd → eep_tdh | tdno |
| WMS | 67Q | 庫存異動查詢 | mes_itio → eep_item, mes_itio → eep_ware | itemno, wareno |
| WMS | 96A | 倉庫儲位設定 | eep_ware → eep_plant, eep_ware_empl → eep_ware, eep_posi → eep_ware | plantno, wareno |
| WMS | 96D | 物料主檔 | eep_item → eep_clas | clasno |
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

## 涵蓋資料表 (44 張)

eep_bmd, eep_bmh, eep_clas, eep_comp, eep_d01, eep_dac, eep_depa, eep_empl, eep_group2, eep_item, eep_iwd_10, eep_iwd_20, eep_iwh, eep_line, eep_menu, eep_mmgrp, eep_mmorg, eep_num8, eep_numh, eep_plant, eep_pos, eep_posi, eep_sdgrp, eep_sdorg, eep_tdd, eep_tdh, eep_tod, eep_toh, eep_trd, eep_trh, eep_ware, eep_ware_empl, groups, mes_itio, pos, pos_log, pos_tod, usergroups, users, vw_POS_CRM_ACRTA, vw_POS_CRM_ACRTB, vw_POS_CRM_ACRTC, vw_POS_CRM_ACRTD, 系統別

## HTML 架構

| 區域 | 說明 |
|------|------|
| 左側導航欄 | 三層結構：dbname → systno → menunum，可折疊展開 |
| 右側主畫布 | 動態渲染該 menunum 的 table card + SVG 關聯線 |
| 頂部欄位 | 顯示 systno breadcrumb + menunum 名稱 + 統計資訊 |
| Table Card | 表頭顯示表名+中文說明，欄位列顯示 COLDEF 資料 |
| FK 標示 | 金色底色 + 鑰匙圖示 |
| 關聯線 | SVG Bezier 曲線 + crow's foot (多端) + circle (一端) |
| Hover | 滑過關聯線高亮兩端 table card |
| 拖曳 | Table card 可自由拖曳調整位置 |
| 底部資訊列 | 33 筆關聯 · 44 張表 · 23 模組 · 6 子系統 |

## 注意事項

- COLDEF 查詢需指定 `db=acpay`，MCP 預設連 master 會報 Invalid object name
- eep_tod/eep_toh 的 COLDEF 有大小寫重複 (eep_tod vs eep_Tod)，已手動合併
- eep_dac、pos_tod、系統別 無 COLDEF 資料，使用 INFORMATION_SCHEMA 欄位名
- eep_ware_empl、eep_mmgrp、eep_mmorg 資料表尚未建立，ERD 顯示預設欄位結構
- FK 鍵值可能是中文欄位名 (契約編號, 連鎖性客戶編號)
- COLDEF CAPTION 有時帶尾碼字母 (契約編號F, 連鎖性客戶編號Y)，FK 匹配時需去尾碼
- FK 鍵名可能是欄位前綴 (sdorg → sdorgno)，匹配時用 startsWith 比對
- A01 中 eep_iwd_10 出現兩次 (服務內容、補充說明)，為同一 FK，ERD 去重顯示
- users/groups/usergroups 表欄位名為大寫 (USERID, GROUPID)，isKeyCol 需忽略大小寫
