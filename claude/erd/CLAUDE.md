# CLAUDE.md — ACPAY ERD 專案

## 專案目標

為 ACPAY 庫存管理系統的資料表建立互動式 ERD 關聯圖，輸出為獨立 HTML 檔案。

## 資料來源

| 項目 | 值 |
|------|------|
| server | `163.17.141.61,8081` |
| database | `acpay` |
| user | `casper` |
| password | `CasChrAliJimJam` |
| GitHub repo | `tocasper-eng/gemio_wms_erd` |

## 涵蓋的資料表 (13 張)

### 組織階層 (Organization Hierarchy)

| 表名 | 中文名 | PK | 說明 |
|------|--------|-----|------|
| `eep_comp` | 公司 | compno | 最上層組織 |
| `eep_plant` | 工廠 | plantno | FK → eep_comp.compno |
| `eep_ware` | 倉庫 | wareno | FK → eep_plant.plantno |
| `eep_posi` | 儲位 | (wareno, posino) | FK → eep_ware.wareno |

### 主檔 (Master Data)

| 表名 | 中文名 | PK | 說明 |
|------|--------|-----|------|
| `eep_item` | 物料主檔 | itemno | 品名、規格、單位、大類 |

### 庫存交易 (Transactions) — 單頭/明細配對

| 單頭 | 明細 | 業務 | FK |
|------|------|------|-----|
| `eep_trh` (trno) | `eep_trd` (trno, trseq) | 繳庫/入庫 | trd.trno → trh.trno |
| `eep_toh` (tono) | `eep_tod` (tono, toseq) | 領用/出庫 | tod.tono → toh.tono |
| `eep_tdh` (tdno) | `eep_tdd` (tdno, tdseq) | 調撥 | tdd.tdno → tdh.tdno |

### 庫存追蹤 (Tracking)

| 表名 | 中文名 | PK | 說明 |
|------|--------|-----|------|
| `eep_itio` | 庫存異動(舊) | — | FK → eep_item.itemno, eep_ware.wareno |
| `mes_itio` | 庫存異動明細(新 WMS) | (iono, ioseq, ioseqseq) | 三層 trigger chain 產生 |

## 關聯定義 (邏輯 FK，非實體約束)

```sql
ALTER TABLE eep_trd   ADD CONSTRAINT FK_eep_trd_eep_trh   FOREIGN KEY (trno)    REFERENCES eep_trh(trno);
ALTER TABLE eep_tod   ADD CONSTRAINT FK_eep_tod_eep_toh   FOREIGN KEY (tono)    REFERENCES eep_toh(tono);
ALTER TABLE eep_tdd   ADD CONSTRAINT FK_eep_tdd_eep_tdh   FOREIGN KEY (tdno)    REFERENCES eep_tdh(tdno);
ALTER TABLE eep_plant ADD CONSTRAINT FK_eep_plant_eep_comp FOREIGN KEY (compno)  REFERENCES eep_comp(compno);
ALTER TABLE eep_ware  ADD CONSTRAINT FK_eep_ware_eep_plant FOREIGN KEY (plantno) REFERENCES eep_plant(plantno);
ALTER TABLE eep_posi  ADD CONSTRAINT FK_eep_posi_eep_ware  FOREIGN KEY (wareno)  REFERENCES eep_ware(wareno);
ALTER TABLE eep_itio  ADD CONSTRAINT FK_eep_itio_eep_item  FOREIGN KEY (itemno)  REFERENCES eep_item(itemno);
ALTER TABLE eep_itio  ADD CONSTRAINT FK_eep_itio_eep_ware  FOREIGN KEY (wareno)  REFERENCES eep_ware(wareno);
```

## 產出檔案

| 檔案 | 說明 |
|------|------|
| `erd_wms.html` | 互動式 ERD 關聯圖 (HTML，可直接瀏覽器開啟) |

## 每次任務完成後

1. 更新本專案的 `CLAUDE.md`、`SKILL.md`
2. 推送至 GitHub `tocasper-eng/gemio_wms_erd`
