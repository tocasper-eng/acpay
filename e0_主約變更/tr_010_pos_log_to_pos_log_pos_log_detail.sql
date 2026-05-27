USE acpay
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_010_pos_log_to_pos_log_pos_log_detail]'))
   DROP TRIGGER [dbo].[tr_010_pos_log_to_pos_log_pos_log_detail]
GO

CREATE TRIGGER tr_010_pos_log_to_pos_log_pos_log_detail ON pos_log
AFTER UPDATE
AS
BEGIN
SET NOCOUNT ON

-- 當契約編號「實際值」被變更時，tr_110 會從 pos 覆寫所有欄位，此時不需記錄差異
-- 不能用 UPDATE(契約編號)，因為 ERP 整列 UPDATE 會讓它永遠為 TRUE
IF EXISTS (
    SELECT 1 FROM inserted i
    INNER JOIN deleted d ON i.num = d.num
    WHERE ISNULL(i.契約編號, '') <> ISNULL(d.契約編號, '')
) RETURN

-- chjernoz 異動表示核准動作 (approve)，不需記錄欄位差異
IF EXISTS (
    SELECT 1 FROM inserted i
    INNER JOIN deleted d ON i.num = d.num
    WHERE ISNULL(i.chjernoz, '') <> ISNULL(d.chjernoz, '')
) RETURN

-- 刪除已存在的明細記錄（重新計算差異）
DELETE pos_log_detail
FROM pos_log_detail
INNER JOIN inserted i ON pos_log_detail.num_pos_log = i.num
WHERE i.num_pos > 0

-- 比對 pos_log (inserted) 與 pos 的每個欄位，將差異寫入 pos_log_detail
INSERT INTO pos_log_detail (fieldname, newvalue, oldvalue, menuflag, 契約編號, num_pos, num_pos_log)
SELECT
    v.fieldname,
    v.newvalue,
    v.oldvalue,
    i.menuflag,
    i.契約編號,
    i.num_pos,
    i.num
FROM inserted i
INNER JOIN pos ON pos.契約編號 = i.契約編號
CROSS APPLY (VALUES
    (N'部門代碼',        CAST(i.部門代碼        AS nvarchar(max)), CAST(pos.部門代碼        AS nvarchar(max))),
    (N'部門名稱',        CAST(i.部門名稱        AS nvarchar(max)), CAST(pos.部門名稱        AS nvarchar(max))),
    (N'公司代碼',        CAST(i.公司代碼        AS nvarchar(max)), CAST(pos.公司代碼        AS nvarchar(max))),
    (N'公司名稱',        CAST(i.公司名稱        AS nvarchar(max)), CAST(pos.公司名稱        AS nvarchar(max))),
    (N'客戶發票抬頭',    CAST(i.客戶發票抬頭    AS nvarchar(max)), CAST(pos.客戶發票抬頭    AS nvarchar(max))),
    (N'狀況代碼',        CAST(i.狀況代碼        AS nvarchar(max)), CAST(pos.狀況代碼        AS nvarchar(max))),
    (N'狀況開通',        CAST(i.狀況開通        AS nvarchar(max)), CAST(pos.狀況開通        AS nvarchar(max))),
    (N'營業員編號',      CAST(i.營業員編號      AS nvarchar(max)), CAST(pos.營業員編號      AS nvarchar(max))),
    (N'營業員名稱',      CAST(i.營業員名稱      AS nvarchar(max)), CAST(pos.營業員名稱      AS nvarchar(max))),
    (N'成約日期',        CAST(i.成約日期        AS nvarchar(max)), CAST(pos.成約日期        AS nvarchar(max))),
    (N'開通日期',        CAST(i.開通日期        AS nvarchar(max)), CAST(pos.開通日期        AS nvarchar(max))),
    (N'系統別',          CAST(i.系統別          AS nvarchar(max)), CAST(pos.系統別          AS nvarchar(max))),
    (N'系統別名稱',      CAST(i.系統別名稱      AS nvarchar(max)), CAST(pos.系統別名稱      AS nvarchar(max))),
    (N'契約書客戶名稱',  CAST(i.契約書客戶名稱  AS nvarchar(max)), CAST(pos.契約書客戶名稱  AS nvarchar(max))),
    (N'成約租賃費',      CAST(i.成約租賃費      AS nvarchar(max)), CAST(pos.成約租賃費      AS nvarchar(max))),
    (N'契約保證金',      CAST(i.契約保證金      AS nvarchar(max)), CAST(pos.契約保證金      AS nvarchar(max))),
    (N'收款週期',        CAST(i.收款週期        AS nvarchar(max)), CAST(pos.收款週期        AS nvarchar(max))),
    (N'最後計費日',      CAST(i.最後計費日      AS nvarchar(max)), CAST(pos.最後計費日      AS nvarchar(max))),
    (N'客戶發票地址',    CAST(i.客戶發票地址    AS nvarchar(max)), CAST(pos.客戶發票地址    AS nvarchar(max))),
    (N'標的物名稱',      CAST(i.標的物名稱      AS nvarchar(max)), CAST(pos.標的物名稱      AS nvarchar(max))),
    (N'標的物地址',      CAST(i.標的物地址      AS nvarchar(max)), CAST(pos.標的物地址      AS nvarchar(max))),
    (N'客戶統編',        CAST(i.客戶統編        AS nvarchar(max)), CAST(pos.客戶統編        AS nvarchar(max))),
    (N'連鎖性客戶編號',  CAST(i.連鎖性客戶編號  AS nvarchar(max)), CAST(pos.連鎖性客戶編號  AS nvarchar(max))),
    (N'連鎖性客戶名稱',  CAST(i.連鎖性客戶名稱  AS nvarchar(max)), CAST(pos.連鎖性客戶名稱  AS nvarchar(max))),
    (N'負責人',          CAST(i.負責人          AS nvarchar(max)), CAST(pos.負責人          AS nvarchar(max))),
    (N'負責人電話',      CAST(i.負責人電話      AS nvarchar(max)), CAST(pos.負責人電話      AS nvarchar(max))),
    (N'負責人手機',      CAST(i.負責人手機      AS nvarchar(max)), CAST(pos.負責人手機      AS nvarchar(max))),
    (N'收款連絡人',      CAST(i.收款連絡人      AS nvarchar(max)), CAST(pos.收款連絡人      AS nvarchar(max))),
    (N'收款連絡人電話',  CAST(i.收款連絡人電話  AS nvarchar(max)), CAST(pos.收款連絡人電話  AS nvarchar(max))),
    (N'收款連絡人手機',  CAST(i.收款連絡人手機  AS nvarchar(max)), CAST(pos.收款連絡人手機  AS nvarchar(max))),
    (N'拜訪連絡人',      CAST(i.拜訪連絡人      AS nvarchar(max)), CAST(pos.拜訪連絡人      AS nvarchar(max))),
    (N'拜訪連絡人電話',  CAST(i.拜訪連絡人電話  AS nvarchar(max)), CAST(pos.拜訪連絡人電話  AS nvarchar(max))),
    (N'拜訪連絡人手機',  CAST(i.拜訪連絡人手機  AS nvarchar(max)), CAST(pos.拜訪連絡人手機  AS nvarchar(max))),
    (N'拜訪公司代碼',    CAST(i.拜訪公司代碼    AS nvarchar(max)), CAST(pos.拜訪公司代碼    AS nvarchar(max))),
    (N'契約期間月數',    CAST(i.契約期間月數    AS nvarchar(max)), CAST(pos.契約期間月數    AS nvarchar(max))),
    (N'近期帳款開立日',  CAST(i.近期帳款開立日  AS nvarchar(max)), CAST(pos.近期帳款開立日  AS nvarchar(max))),
    (N'契約書統一編號',  CAST(i.契約書統一編號  AS nvarchar(max)), CAST(pos.契約書統一編號  AS nvarchar(max))),
    (N'發票服務費',      CAST(i.發票服務費      AS nvarchar(max)), CAST(pos.發票服務費      AS nvarchar(max))),
    (N'發票服務起日',    CAST(i.發票服務起日    AS nvarchar(max)), CAST(pos.發票服務起日    AS nvarchar(max))),
    (N'發票服務迄日',    CAST(i.發票服務迄日    AS nvarchar(max)), CAST(pos.發票服務迄日    AS nvarchar(max))),
    (N'優待月數',        CAST(i.優待月數        AS nvarchar(max)), CAST(pos.優待月數        AS nvarchar(max))),
    (N'優待週期',        CAST(i.優待週期        AS nvarchar(max)), CAST(pos.優待週期        AS nvarchar(max))),
    (N'優待開始日',      CAST(i.優待開始日      AS nvarchar(max)), CAST(pos.優待開始日      AS nvarchar(max))),
    (N'上次優待日',      CAST(i.上次優待日      AS nvarchar(max)), CAST(pos.上次優待日      AS nvarchar(max))),
    (N'郵件信箱',        CAST(i.郵件信箱        AS nvarchar(max)), CAST(pos.郵件信箱        AS nvarchar(max))),
    (N'安裝服務費',      CAST(i.安裝服務費      AS nvarchar(max)), CAST(pos.安裝服務費      AS nvarchar(max))),
    (N'安裝保證金',      CAST(i.安裝保證金      AS nvarchar(max)), CAST(pos.安裝保證金      AS nvarchar(max))),
    (N'服務起日',        CAST(i.服務起日        AS nvarchar(max)), CAST(pos.服務起日        AS nvarchar(max))),
    (N'服務迄日',        CAST(i.服務迄日        AS nvarchar(max)), CAST(pos.服務迄日        AS nvarchar(max))),
    (N'暫停起日',        CAST(i.暫停起日        AS nvarchar(max)), CAST(pos.暫停起日        AS nvarchar(max))),
    (N'暫停迄日',        CAST(i.暫停迄日        AS nvarchar(max)), CAST(pos.暫停迄日        AS nvarchar(max))),
    (N'停開起日',        CAST(i.停開起日        AS nvarchar(max)), CAST(pos.停開起日        AS nvarchar(max))),
    (N'停開迄日',        CAST(i.停開迄日        AS nvarchar(max)), CAST(pos.停開迄日        AS nvarchar(max))),
    (N'解約日',          CAST(i.解約日          AS nvarchar(max)), CAST(pos.解約日          AS nvarchar(max))),
    (N'備用欄位',        CAST(i.備用欄位        AS nvarchar(max)), CAST(pos.備用欄位        AS nvarchar(max))),
    (N'每期發票金額',    CAST(i.每期發票金額    AS nvarchar(max)), CAST(pos.每期發票金額    AS nvarchar(max))),
    (N'付款方式',        CAST(i.付款方式        AS nvarchar(max)), CAST(pos.付款方式        AS nvarchar(max))),
    (N'合併開立',        CAST(i.合併開立        AS nvarchar(max)), CAST(pos.合併開立        AS nvarchar(max))),
    (N'提前開立月日',    CAST(i.提前開立月日    AS nvarchar(max)), CAST(pos.提前開立月日    AS nvarchar(max))),
    (N'特殊月份',        CAST(i.特殊月份        AS nvarchar(max)), CAST(pos.特殊月份        AS nvarchar(max))),
    (N'特殊條件說明',    CAST(i.特殊條件說明    AS nvarchar(max)), CAST(pos.特殊條件說明    AS nvarchar(max))),
    (N'滙款資料顯示1',   CAST(i.滙款資料顯示1   AS nvarchar(max)), CAST(pos.滙款資料顯示1   AS nvarchar(max))),
    (N'滙款資料顯示2',   CAST(i.滙款資料顯示2   AS nvarchar(max)), CAST(pos.滙款資料顯示2   AS nvarchar(max))),
    (N'固定虛擬帳號',    CAST(i.固定虛擬帳號    AS nvarchar(max)), CAST(pos.固定虛擬帳號    AS nvarchar(max))),
    (N'暫停收費月份',    CAST(i.暫停收費月份    AS nvarchar(max)), CAST(pos.暫停收費月份    AS nvarchar(max))),
    (N'erp店家代號',     CAST(i.erp店家代號     AS nvarchar(max)), CAST(pos.erp店家代號     AS nvarchar(max))),
    (N'人工處理',        CAST(i.人工處理        AS nvarchar(max)), CAST(pos.人工處理        AS nvarchar(max))),
    (N'備註',            CAST(i.備註            AS nvarchar(max)), CAST(pos.備註            AS nvarchar(max))),
    (N'收款周期',        CAST(i.收款周期        AS nvarchar(max)), CAST(pos.收款周期        AS nvarchar(max))),
    (N'最後計費日期',    CAST(i.最後計費日期    AS nvarchar(max)), CAST(pos.最後計費日期    AS nvarchar(max))),
    (N'租賃費加日',      CAST(i.租賃費加日      AS nvarchar(max)), CAST(pos.租賃費加日      AS nvarchar(max))),
    (N'發票服務日期',    CAST(i.發票服務日期    AS nvarchar(max)), CAST(pos.發票服務日期    AS nvarchar(max))),
    (N'加購開始日間',    CAST(i.加購開始日間    AS nvarchar(max)), CAST(pos.加購開始日間    AS nvarchar(max))),
    (N'加購結束日間',    CAST(i.加購結束日間    AS nvarchar(max)), CAST(pos.加購結束日間    AS nvarchar(max))),
    (N'RD欄位',          CAST(i.RD欄位          AS nvarchar(max)), CAST(pos.RD欄位          AS nvarchar(max))),
    (N'指定列印代碼',    CAST(i.指定列印代碼    AS nvarchar(max)), CAST(pos.指定列印代碼    AS nvarchar(max))),
    (N'帳單寄送',        CAST(i.帳單寄送        AS nvarchar(max)), CAST(pos.帳單寄送        AS nvarchar(max))),
    (N'客服紀錄備註',    CAST(i.客服紀錄備註    AS nvarchar(max)), CAST(pos.客服紀錄備註    AS nvarchar(max)))
) AS v(fieldname, newvalue, oldvalue)
WHERE i.num_pos > 0
  AND ISNULL(v.newvalue, '') <> ISNULL(v.oldvalue, '')

END

GO
