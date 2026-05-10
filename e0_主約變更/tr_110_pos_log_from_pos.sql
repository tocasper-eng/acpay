USE acpay
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_110_pos_log_from_pos]'))
   DROP TRIGGER [dbo].[tr_110_pos_log_from_pos]
GO

create trigger tr_110_pos_log_from_pos on pos_log
after insert , update
as
begin

if update(契約編號)
begin

    update pos_log set
        契約狀態        = pos.契約狀態,
        部門代碼        = pos.部門代碼,
        部門名稱        = pos.部門名稱,
        公司代碼        = pos.公司代碼,
        公司名稱        = pos.公司名稱,
        客戶發票抬頭    = pos.客戶發票抬頭,
        狀況代碼        = pos.狀況代碼,
        狀況開通        = pos.狀況開通,
        營業員編號      = pos.營業員編號,
        營業員名稱      = pos.營業員名稱,
        成約日期        = pos.成約日期,
        開通日期        = pos.開通日期,
        系統別          = pos.系統別,
        系統別名稱      = pos.系統別名稱,
        契約書客戶名稱  = pos.契約書客戶名稱,
        成約租賃費      = pos.成約租賃費,
        契約保證金      = pos.契約保證金,
        收款週期        = pos.收款週期,
        最後計費日      = pos.最後計費日,
        客戶發票地址    = pos.客戶發票地址,
        標的物名稱      = pos.標的物名稱,
        標的物地址      = pos.標的物地址,
        客戶統編        = pos.客戶統編,
        連鎖性客戶編號  = pos.連鎖性客戶編號,
        連鎖性客戶名稱  = pos.連鎖性客戶名稱,
        負責人          = pos.負責人,
        負責人電話      = pos.負責人電話,
        負責人手機      = pos.負責人手機,
        收款連絡人      = pos.收款連絡人,
        收款連絡人電話  = pos.收款連絡人電話,
        收款連絡人手機  = pos.收款連絡人手機,
        拜訪連絡人      = pos.拜訪連絡人,
        拜訪連絡人電話  = pos.拜訪連絡人電話,
        拜訪連絡人手機  = pos.拜訪連絡人手機,
        拜訪公司代碼    = pos.拜訪公司代碼,
        契約期間月數    = pos.契約期間月數,
        近期帳款開立日  = pos.近期帳款開立日,
        契約書統一編號  = pos.契約書統一編號,
        發票服務費      = pos.發票服務費,
        發票服務起日    = pos.發票服務起日,
        發票服務迄日    = pos.發票服務迄日,
        優待月數        = pos.優待月數,
        優待週期        = pos.優待週期,
        優待開始日      = pos.優待開始日,
        上次優待日      = pos.上次優待日,
        郵件信箱        = pos.郵件信箱,
        安裝服務費      = pos.安裝服務費,
        安裝保證金      = pos.安裝保證金,
        服務起日        = pos.服務起日,
        服務迄日        = pos.服務迄日,
        暫停起日        = pos.暫停起日,
        暫停迄日        = pos.暫停迄日,
        停開起日        = pos.停開起日,
        停開迄日        = pos.停開迄日,
        解約日          = pos.解約日,
        備用欄位        = pos.備用欄位,
        每期發票金額    = pos.每期發票金額,
        付款方式        = pos.付款方式,
        合併開立        = pos.合併開立,
        提前開立月日    = pos.提前開立月日,
        特殊月份        = pos.特殊月份,
        特殊條件說明    = pos.特殊條件說明,
        滙款資料顯示1   = pos.滙款資料顯示1,
        滙款資料顯示2   = pos.滙款資料顯示2,
        固定虛擬帳號    = pos.固定虛擬帳號,
        暫停收費月份    = pos.暫停收費月份,
        erp店家代號     = pos.erp店家代號,
        人工處理        = pos.人工處理,
        備註            = pos.備註,
        收款周期        = pos.收款周期,
        最後計費日期    = pos.最後計費日期,
        租賃費加日      = pos.租賃費加日,
        發票服務日期    = pos.發票服務日期,
        加購開始日間    = pos.加購開始日間,
        加購結束日間    = pos.加購結束日間,
        RD欄位          = pos.RD欄位,
        指定列印代碼    = pos.指定列印代碼,
        num_pos         = pos.num
    FROM inserted
    INNER JOIN pos ON pos.契約編號 = inserted.契約編號
    WHERE pos_log.num = inserted.num

end

end

GO
