USE acpay
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[up_e01_zy]') AND type in (N'P', N'PC'))
   DROP PROCEDURE [dbo].[up_e01_zy]
GO

-- 主約變更：將 pos_log 中已變動的欄位寫回 pos，並把變動欄位的新舊值註記在 pos_log.remark
-- 用法： exec up_e01_zy @menuflag = 'POS_log_00_xxxxxxxxxxxxx'
-- 註：契約編號 不回寫 pos (它是 tr_110 的觸發 key，由 pos 端為主)
CREATE PROCEDURE up_e01_zy
(
    @menuflag char(20),
@chjerno  nvarchar(99) 

)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @num_pos bigint
    DECLARE @diff    nvarchar(max) = N''
    DECLARE @stamp   nvarchar(20)  = CONVERT(nvarchar(20), GETDATE(), 120)
	declare @chjernoz  nvarchar(100) 

    -- 取得對應 pos 的 PK
    SELECT @num_pos = num_pos , @chjernoz = chjernoz 
    FROM pos_log
    WHERE menuflag = @menuflag

 
 

if substring(isnull(@chjernoz,'') ,1,1) = 'Y' return 

 
set @chjernoz = 'Y::' + isnull(@chjerno,'') 
 
 
update eep_iwh set chjernoz = @chjernoz where menuflag = @menuflag 




    IF @num_pos IS NULL RETURN

    -- 比對 pos_log 與 pos 各欄位差異 (寫回前)，記錄 舊值→新值
    SELECT @diff =
         CASE WHEN ISNULL(l.契約狀態      ,N'') <> ISNULL(p.契約狀態      ,N'') THEN N'契約狀態('       +ISNULL(p.契約狀態      ,N'')+N'→'+ISNULL(l.契約狀態      ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.部門代碼      ,N'') <> ISNULL(p.部門代碼      ,N'') THEN N'部門代碼('       +ISNULL(p.部門代碼      ,N'')+N'→'+ISNULL(l.部門代碼      ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.部門名稱      ,N'') <> ISNULL(p.部門名稱      ,N'') THEN N'部門名稱('       +ISNULL(p.部門名稱      ,N'')+N'→'+ISNULL(l.部門名稱      ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.公司代碼      ,N'') <> ISNULL(p.公司代碼      ,N'') THEN N'公司代碼('       +ISNULL(p.公司代碼      ,N'')+N'→'+ISNULL(l.公司代碼      ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.公司名稱      ,N'') <> ISNULL(p.公司名稱      ,N'') THEN N'公司名稱('       +ISNULL(p.公司名稱      ,N'')+N'→'+ISNULL(l.公司名稱      ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.客戶發票抬頭  ,N'') <> ISNULL(p.客戶發票抬頭  ,N'') THEN N'客戶發票抬頭('   +ISNULL(p.客戶發票抬頭  ,N'')+N'→'+ISNULL(l.客戶發票抬頭  ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.狀況代碼      ,N'') <> ISNULL(p.狀況代碼      ,N'') THEN N'狀況代碼('       +ISNULL(p.狀況代碼      ,N'')+N'→'+ISNULL(l.狀況代碼      ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.狀況開通      ,N'') <> ISNULL(p.狀況開通      ,N'') THEN N'狀況開通('       +ISNULL(p.狀況開通      ,N'')+N'→'+ISNULL(l.狀況開通      ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.營業員編號    ,N'') <> ISNULL(p.營業員編號    ,N'') THEN N'營業員編號('     +ISNULL(p.營業員編號    ,N'')+N'→'+ISNULL(l.營業員編號    ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.營業員名稱    ,N'') <> ISNULL(p.營業員名稱    ,N'') THEN N'營業員名稱('     +ISNULL(p.營業員名稱    ,N'')+N'→'+ISNULL(l.營業員名稱    ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.成約日期      ,'')  <> ISNULL(p.成約日期      ,'')  THEN N'成約日期('       +ISNULL(p.成約日期      ,'') +N'→'+ISNULL(l.成約日期      ,'') +N');' ELSE N'' END
       + CASE WHEN ISNULL(l.開通日期      ,'')  <> ISNULL(p.開通日期      ,'')  THEN N'開通日期('       +ISNULL(p.開通日期      ,'') +N'→'+ISNULL(l.開通日期      ,'') +N');' ELSE N'' END
       + CASE WHEN ISNULL(l.系統別        ,N'') <> ISNULL(p.系統別        ,N'') THEN N'系統別('         +ISNULL(p.系統別        ,N'')+N'→'+ISNULL(l.系統別        ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.系統別名稱    ,N'') <> ISNULL(p.系統別名稱    ,N'') THEN N'系統別名稱('     +ISNULL(p.系統別名稱    ,N'')+N'→'+ISNULL(l.系統別名稱    ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.契約書客戶名稱,N'') <> ISNULL(p.契約書客戶名稱,N'') THEN N'契約書客戶名稱(' +ISNULL(p.契約書客戶名稱,N'')+N'→'+ISNULL(l.契約書客戶名稱,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.成約租賃費    , 0)  <> ISNULL(p.成約租賃費    , 0)  THEN N'成約租賃費('     +CONVERT(nvarchar,ISNULL(p.成約租賃費    ,0))+N'→'+CONVERT(nvarchar,ISNULL(l.成約租賃費    ,0))+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.契約保證金    , 0)  <> ISNULL(p.契約保證金    , 0)  THEN N'契約保證金('     +CONVERT(nvarchar,ISNULL(p.契約保證金    ,0))+N'→'+CONVERT(nvarchar,ISNULL(l.契約保證金    ,0))+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.收款週期      , 0)  <> ISNULL(p.收款週期      , 0)  THEN N'收款週期('       +CONVERT(nvarchar,ISNULL(p.收款週期      ,0))+N'→'+CONVERT(nvarchar,ISNULL(l.收款週期      ,0))+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.最後計費日    ,'')  <> ISNULL(p.最後計費日    ,'')  THEN N'最後計費日('     +ISNULL(p.最後計費日    ,'') +N'→'+ISNULL(l.最後計費日    ,'') +N');' ELSE N'' END
       + CASE WHEN ISNULL(l.客戶發票地址  ,N'') <> ISNULL(p.客戶發票地址  ,N'') THEN N'客戶發票地址('   +ISNULL(p.客戶發票地址  ,N'')+N'→'+ISNULL(l.客戶發票地址  ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.標的物名稱    ,N'') <> ISNULL(p.標的物名稱    ,N'') THEN N'標的物名稱('     +ISNULL(p.標的物名稱    ,N'')+N'→'+ISNULL(l.標的物名稱    ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.標的物地址    ,N'') <> ISNULL(p.標的物地址    ,N'') THEN N'標的物地址('     +ISNULL(p.標的物地址    ,N'')+N'→'+ISNULL(l.標的物地址    ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.客戶統編      ,N'') <> ISNULL(p.客戶統編      ,N'') THEN N'客戶統編('       +ISNULL(p.客戶統編      ,N'')+N'→'+ISNULL(l.客戶統編      ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.連鎖性客戶編號,N'') <> ISNULL(p.連鎖性客戶編號,N'') THEN N'連鎖性客戶編號(' +ISNULL(p.連鎖性客戶編號,N'')+N'→'+ISNULL(l.連鎖性客戶編號,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.連鎖性客戶名稱,N'') <> ISNULL(p.連鎖性客戶名稱,N'') THEN N'連鎖性客戶名稱(' +ISNULL(p.連鎖性客戶名稱,N'')+N'→'+ISNULL(l.連鎖性客戶名稱,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.負責人        ,N'') <> ISNULL(p.負責人        ,N'') THEN N'負責人('         +ISNULL(p.負責人        ,N'')+N'→'+ISNULL(l.負責人        ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.負責人電話    ,N'') <> ISNULL(p.負責人電話    ,N'') THEN N'負責人電話('     +ISNULL(p.負責人電話    ,N'')+N'→'+ISNULL(l.負責人電話    ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.負責人手機    ,N'') <> ISNULL(p.負責人手機    ,N'') THEN N'負責人手機('     +ISNULL(p.負責人手機    ,N'')+N'→'+ISNULL(l.負責人手機    ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.收款連絡人    ,N'') <> ISNULL(p.收款連絡人    ,N'') THEN N'收款連絡人('     +ISNULL(p.收款連絡人    ,N'')+N'→'+ISNULL(l.收款連絡人    ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.收款連絡人電話,N'') <> ISNULL(p.收款連絡人電話,N'') THEN N'收款連絡人電話(' +ISNULL(p.收款連絡人電話,N'')+N'→'+ISNULL(l.收款連絡人電話,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.收款連絡人手機,N'') <> ISNULL(p.收款連絡人手機,N'') THEN N'收款連絡人手機(' +ISNULL(p.收款連絡人手機,N'')+N'→'+ISNULL(l.收款連絡人手機,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.拜訪連絡人    ,N'') <> ISNULL(p.拜訪連絡人    ,N'') THEN N'拜訪連絡人('     +ISNULL(p.拜訪連絡人    ,N'')+N'→'+ISNULL(l.拜訪連絡人    ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.拜訪連絡人電話,N'') <> ISNULL(p.拜訪連絡人電話,N'') THEN N'拜訪連絡人電話(' +ISNULL(p.拜訪連絡人電話,N'')+N'→'+ISNULL(l.拜訪連絡人電話,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.拜訪連絡人手機,N'') <> ISNULL(p.拜訪連絡人手機,N'') THEN N'拜訪連絡人手機(' +ISNULL(p.拜訪連絡人手機,N'')+N'→'+ISNULL(l.拜訪連絡人手機,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.拜訪公司代碼  ,N'') <> ISNULL(p.拜訪公司代碼  ,N'') THEN N'拜訪公司代碼('   +ISNULL(p.拜訪公司代碼  ,N'')+N'→'+ISNULL(l.拜訪公司代碼  ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.契約期間月數  , 0)  <> ISNULL(p.契約期間月數  , 0)  THEN N'契約期間月數('   +CONVERT(nvarchar,ISNULL(p.契約期間月數  ,0))+N'→'+CONVERT(nvarchar,ISNULL(l.契約期間月數  ,0))+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.近期帳款開立日,'')  <> ISNULL(p.近期帳款開立日,'')  THEN N'近期帳款開立日(' +ISNULL(p.近期帳款開立日,'') +N'→'+ISNULL(l.近期帳款開立日,'') +N');' ELSE N'' END
       + CASE WHEN ISNULL(l.契約書統一編號,N'') <> ISNULL(p.契約書統一編號,N'') THEN N'契約書統一編號(' +ISNULL(p.契約書統一編號,N'')+N'→'+ISNULL(l.契約書統一編號,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.發票服務費    , 0)  <> ISNULL(p.發票服務費    , 0)  THEN N'發票服務費('     +CONVERT(nvarchar,ISNULL(p.發票服務費    ,0))+N'→'+CONVERT(nvarchar,ISNULL(l.發票服務費    ,0))+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.發票服務起日  ,'')  <> ISNULL(p.發票服務起日  ,'')  THEN N'發票服務起日('   +ISNULL(p.發票服務起日  ,'') +N'→'+ISNULL(l.發票服務起日  ,'') +N');' ELSE N'' END
       + CASE WHEN ISNULL(l.發票服務迄日  ,'')  <> ISNULL(p.發票服務迄日  ,'')  THEN N'發票服務迄日('   +ISNULL(p.發票服務迄日  ,'') +N'→'+ISNULL(l.發票服務迄日  ,'') +N');' ELSE N'' END
       + CASE WHEN ISNULL(l.優待月數      , 0)  <> ISNULL(p.優待月數      , 0)  THEN N'優待月數('       +CONVERT(nvarchar,ISNULL(p.優待月數      ,0))+N'→'+CONVERT(nvarchar,ISNULL(l.優待月數      ,0))+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.優待週期      , 0)  <> ISNULL(p.優待週期      , 0)  THEN N'優待週期('       +CONVERT(nvarchar,ISNULL(p.優待週期      ,0))+N'→'+CONVERT(nvarchar,ISNULL(l.優待週期      ,0))+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.優待開始日    ,'')  <> ISNULL(p.優待開始日    ,'')  THEN N'優待開始日('     +ISNULL(p.優待開始日    ,'') +N'→'+ISNULL(l.優待開始日    ,'') +N');' ELSE N'' END
       + CASE WHEN ISNULL(l.上次優待日    ,'')  <> ISNULL(p.上次優待日    ,'')  THEN N'上次優待日('     +ISNULL(p.上次優待日    ,'') +N'→'+ISNULL(l.上次優待日    ,'') +N');' ELSE N'' END
       + CASE WHEN ISNULL(l.郵件信箱      ,N'') <> ISNULL(p.郵件信箱      ,N'') THEN N'郵件信箱('       +ISNULL(p.郵件信箱      ,N'')+N'→'+ISNULL(l.郵件信箱      ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.安裝服務費    , 0)  <> ISNULL(p.安裝服務費    , 0)  THEN N'安裝服務費('     +CONVERT(nvarchar,ISNULL(p.安裝服務費    ,0))+N'→'+CONVERT(nvarchar,ISNULL(l.安裝服務費    ,0))+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.安裝保證金    , 0)  <> ISNULL(p.安裝保證金    , 0)  THEN N'安裝保證金('     +CONVERT(nvarchar,ISNULL(p.安裝保證金    ,0))+N'→'+CONVERT(nvarchar,ISNULL(l.安裝保證金    ,0))+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.服務起日      ,'')  <> ISNULL(p.服務起日      ,'')  THEN N'服務起日('       +ISNULL(p.服務起日      ,'') +N'→'+ISNULL(l.服務起日      ,'') +N');' ELSE N'' END
       + CASE WHEN ISNULL(l.服務迄日      ,'')  <> ISNULL(p.服務迄日      ,'')  THEN N'服務迄日('       +ISNULL(p.服務迄日      ,'') +N'→'+ISNULL(l.服務迄日      ,'') +N');' ELSE N'' END
       + CASE WHEN ISNULL(l.暫停起日      ,'')  <> ISNULL(p.暫停起日      ,'')  THEN N'暫停起日('       +ISNULL(p.暫停起日      ,'') +N'→'+ISNULL(l.暫停起日      ,'') +N');' ELSE N'' END
       + CASE WHEN ISNULL(l.暫停迄日      ,'')  <> ISNULL(p.暫停迄日      ,'')  THEN N'暫停迄日('       +ISNULL(p.暫停迄日      ,'') +N'→'+ISNULL(l.暫停迄日      ,'') +N');' ELSE N'' END
       + CASE WHEN ISNULL(l.停開起日      ,'')  <> ISNULL(p.停開起日      ,'')  THEN N'停開起日('       +ISNULL(p.停開起日      ,'') +N'→'+ISNULL(l.停開起日      ,'') +N');' ELSE N'' END
       + CASE WHEN ISNULL(l.停開迄日      ,'')  <> ISNULL(p.停開迄日      ,'')  THEN N'停開迄日('       +ISNULL(p.停開迄日      ,'') +N'→'+ISNULL(l.停開迄日      ,'') +N');' ELSE N'' END
       + CASE WHEN ISNULL(l.解約日        ,'')  <> ISNULL(p.解約日        ,'')  THEN N'解約日('         +ISNULL(p.解約日        ,'') +N'→'+ISNULL(l.解約日        ,'') +N');' ELSE N'' END
       + CASE WHEN ISNULL(l.備用欄位      ,N'') <> ISNULL(p.備用欄位      ,N'') THEN N'備用欄位('       +ISNULL(p.備用欄位      ,N'')+N'→'+ISNULL(l.備用欄位      ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.每期發票金額  , 0)  <> ISNULL(p.每期發票金額  , 0)  THEN N'每期發票金額('   +CONVERT(nvarchar,ISNULL(p.每期發票金額  ,0))+N'→'+CONVERT(nvarchar,ISNULL(l.每期發票金額  ,0))+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.付款方式      ,N'') <> ISNULL(p.付款方式      ,N'') THEN N'付款方式('       +ISNULL(p.付款方式      ,N'')+N'→'+ISNULL(l.付款方式      ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.合併開立      ,N'') <> ISNULL(p.合併開立      ,N'') THEN N'合併開立('       +ISNULL(p.合併開立      ,N'')+N'→'+ISNULL(l.合併開立      ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.提前開立月日  ,N'') <> ISNULL(p.提前開立月日  ,N'') THEN N'提前開立月日('   +ISNULL(p.提前開立月日  ,N'')+N'→'+ISNULL(l.提前開立月日  ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.特殊月份      ,N'') <> ISNULL(p.特殊月份      ,N'') THEN N'特殊月份('       +ISNULL(p.特殊月份      ,N'')+N'→'+ISNULL(l.特殊月份      ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.特殊條件說明  ,N'') <> ISNULL(p.特殊條件說明  ,N'') THEN N'特殊條件說明('   +ISNULL(p.特殊條件說明  ,N'')+N'→'+ISNULL(l.特殊條件說明  ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.滙款資料顯示1 ,N'') <> ISNULL(p.滙款資料顯示1 ,N'') THEN N'滙款資料顯示1('  +ISNULL(p.滙款資料顯示1 ,N'')+N'→'+ISNULL(l.滙款資料顯示1 ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.滙款資料顯示2 ,N'') <> ISNULL(p.滙款資料顯示2 ,N'') THEN N'滙款資料顯示2('  +ISNULL(p.滙款資料顯示2 ,N'')+N'→'+ISNULL(l.滙款資料顯示2 ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.固定虛擬帳號  ,N'') <> ISNULL(p.固定虛擬帳號  ,N'') THEN N'固定虛擬帳號('   +ISNULL(p.固定虛擬帳號  ,N'')+N'→'+ISNULL(l.固定虛擬帳號  ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.暫停收費月份  ,N'') <> ISNULL(p.暫停收費月份  ,N'') THEN N'暫停收費月份('   +ISNULL(p.暫停收費月份  ,N'')+N'→'+ISNULL(l.暫停收費月份  ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.erp店家代號   ,N'') <> ISNULL(p.erp店家代號   ,N'') THEN N'erp店家代號('    +ISNULL(p.erp店家代號   ,N'')+N'→'+ISNULL(l.erp店家代號   ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.人工處理      ,N'') <> ISNULL(p.人工處理      ,N'') THEN N'人工處理('       +ISNULL(p.人工處理      ,N'')+N'→'+ISNULL(l.人工處理      ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.備註          ,N'') <> ISNULL(p.備註          ,N'') THEN N'備註('           +ISNULL(p.備註          ,N'')+N'→'+ISNULL(l.備註          ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.收款周期      ,N'') <> ISNULL(p.收款周期      ,N'') THEN N'收款周期('       +ISNULL(p.收款周期      ,N'')+N'→'+ISNULL(l.收款周期      ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.最後計費日期  ,'')  <> ISNULL(p.最後計費日期  ,'')  THEN N'最後計費日期('   +ISNULL(p.最後計費日期  ,'') +N'→'+ISNULL(l.最後計費日期  ,'') +N');' ELSE N'' END
       + CASE WHEN ISNULL(l.租賃費加日    ,'')  <> ISNULL(p.租賃費加日    ,'')  THEN N'租賃費加日('     +ISNULL(p.租賃費加日    ,'') +N'→'+ISNULL(l.租賃費加日    ,'') +N');' ELSE N'' END
       + CASE WHEN ISNULL(l.發票服務日期  ,'')  <> ISNULL(p.發票服務日期  ,'')  THEN N'發票服務日期('   +ISNULL(p.發票服務日期  ,'') +N'→'+ISNULL(l.發票服務日期  ,'') +N');' ELSE N'' END
       + CASE WHEN ISNULL(l.加購開始日間  ,'')  <> ISNULL(p.加購開始日間  ,'')  THEN N'加購開始日間('   +ISNULL(p.加購開始日間  ,'') +N'→'+ISNULL(l.加購開始日間  ,'') +N');' ELSE N'' END
       + CASE WHEN ISNULL(l.加購結束日間  ,'')  <> ISNULL(p.加購結束日間  ,'')  THEN N'加購結束日間('   +ISNULL(p.加購結束日間  ,'') +N'→'+ISNULL(l.加購結束日間  ,'') +N');' ELSE N'' END
       + CASE WHEN ISNULL(l.RD欄位        ,N'') <> ISNULL(p.RD欄位        ,N'') THEN N'RD欄位('         +ISNULL(p.RD欄位        ,N'')+N'→'+ISNULL(l.RD欄位        ,N'')+N');' ELSE N'' END
       + CASE WHEN ISNULL(l.指定列印代碼  ,N'') <> ISNULL(p.指定列印代碼  ,N'') THEN N'指定列印代碼('   +ISNULL(p.指定列印代碼  ,N'')+N'→'+ISNULL(l.指定列印代碼  ,N'')+N');' ELSE N'' END
    FROM pos_log l
    INNER JOIN pos p ON p.num = l.num_pos
    WHERE l.menuflag = @menuflag

    -- 沒有任何欄位變動 → 直接結束
    IF LEN(ISNULL(@diff, N'')) = 0 RETURN

    -- 將 pos_log 已變動值寫回 pos (以 pos.num = pos_log.num_pos 對應；不回寫 契約編號)
    UPDATE pos SET
        契約狀態        = l.契約狀態,
        部門代碼        = l.部門代碼,
        部門名稱        = l.部門名稱,
        公司代碼        = l.公司代碼,
        公司名稱        = l.公司名稱,
        客戶發票抬頭    = l.客戶發票抬頭,
        狀況代碼        = l.狀況代碼,
        狀況開通        = l.狀況開通,
        營業員編號      = l.營業員編號,
        營業員名稱      = l.營業員名稱,
        成約日期        = l.成約日期,
        開通日期        = l.開通日期,
        系統別          = l.系統別,
        系統別名稱      = l.系統別名稱,
        契約書客戶名稱  = l.契約書客戶名稱,
        成約租賃費      = l.成約租賃費,
        契約保證金      = l.契約保證金,
        收款週期        = l.收款週期,
        最後計費日      = l.最後計費日,
        客戶發票地址    = l.客戶發票地址,
        標的物名稱      = l.標的物名稱,
        標的物地址      = l.標的物地址,
        客戶統編        = l.客戶統編,
        連鎖性客戶編號  = l.連鎖性客戶編號,
        連鎖性客戶名稱  = l.連鎖性客戶名稱,
        負責人          = l.負責人,
        負責人電話      = l.負責人電話,
        負責人手機      = l.負責人手機,
        收款連絡人      = l.收款連絡人,
        收款連絡人電話  = l.收款連絡人電話,
        收款連絡人手機  = l.收款連絡人手機,
        拜訪連絡人      = l.拜訪連絡人,
        拜訪連絡人電話  = l.拜訪連絡人電話,
        拜訪連絡人手機  = l.拜訪連絡人手機,
        拜訪公司代碼    = l.拜訪公司代碼,
        契約期間月數    = l.契約期間月數,
        近期帳款開立日  = l.近期帳款開立日,
        契約書統一編號  = l.契約書統一編號,
        發票服務費      = l.發票服務費,
        發票服務起日    = l.發票服務起日,
        發票服務迄日    = l.發票服務迄日,
        優待月數        = l.優待月數,
        優待週期        = l.優待週期,
        優待開始日      = l.優待開始日,
        上次優待日      = l.上次優待日,
        郵件信箱        = l.郵件信箱,
        安裝服務費      = l.安裝服務費,
        安裝保證金      = l.安裝保證金,
        服務起日        = l.服務起日,
        服務迄日        = l.服務迄日,
        暫停起日        = l.暫停起日,
        暫停迄日        = l.暫停迄日,
        停開起日        = l.停開起日,
        停開迄日        = l.停開迄日,
        解約日          = l.解約日,
        備用欄位        = l.備用欄位,
        每期發票金額    = l.每期發票金額,
        付款方式        = l.付款方式,
        合併開立        = l.合併開立,
        提前開立月日    = l.提前開立月日,
        特殊月份        = l.特殊月份,
        特殊條件說明    = l.特殊條件說明,
        滙款資料顯示1   = l.滙款資料顯示1,
        滙款資料顯示2   = l.滙款資料顯示2,
        固定虛擬帳號    = l.固定虛擬帳號,
        暫停收費月份    = l.暫停收費月份,
        erp店家代號     = l.erp店家代號,
        人工處理        = l.人工處理,
        備註            = l.備註,
        收款周期        = l.收款周期,
        最後計費日期    = l.最後計費日期,
        租賃費加日      = l.租賃費加日,
        發票服務日期    = l.發票服務日期,
        加購開始日間    = l.加購開始日間,
        加購結束日間    = l.加購結束日間,
        RD欄位          = l.RD欄位,
        指定列印代碼    = l.指定列印代碼
    FROM pos_log l
    WHERE pos.num = l.num_pos AND l.menuflag = @menuflag

    -- 註記變動欄位的舊→新值於 pos_log.remark (nvarchar(max))
    UPDATE pos_log
    SET remark = ISNULL(remark, N'') + N'['+@stamp+N']寫回pos:'+@diff
    WHERE menuflag = @menuflag

END
GO
