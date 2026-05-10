use acpay 

go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pos_log]') AND type in (N'U'))
   DROP TABLE  pos_log
GO
 
 --alter table pos_log alter column  remark        nvarchar(max)        null
 --主約變更
CREATE TABLE pos_log(
 
	[契約狀態] [nvarchar](20) not NULL,
	[部門代碼] [nvarchar](20) NULL,
	[部門名稱] [nvarchar](20) NULL,
	[公司代碼] [nvarchar](20) NULL,
	[公司名稱] [nvarchar](20) NULL,
	[契約編號] [nvarchar](20) NULL,
	[客戶發票抬頭] [nvarchar](99) NULL,
	[狀況代碼] [nvarchar](20) NULL,
	[狀況開通] [nvarchar](20) NULL,
	[營業員編號] [nvarchar](20) NULL,
	[營業員名稱] [nvarchar](20) NULL,
	[成約日期] [char](8) NULL,
	[開通日期] [char](8) NULL,
	[系統別] [nvarchar](20) NULL,
	[系統別名稱] [nvarchar](20) NULL,
	[契約書客戶名稱] [nvarchar](99) NULL,
	[成約租賃費] [int] NULL,
	[契約保證金] [int] NULL,
	[收款週期] [int] NULL,
	[最後計費日] [char](8) NULL,
	[客戶發票地址] [nvarchar](99) NULL,
	[標的物名稱] [nvarchar](99) NULL,
	[標的物地址] [nvarchar](99) NULL,
	[客戶統編] [nvarchar](20) NULL,
	[連鎖性客戶編號] [nvarchar](20) NULL,
	[連鎖性客戶名稱] [nvarchar](99) NULL,
	[負責人] [nvarchar](20) NULL,
	[負責人電話] [nvarchar](20) NULL,
	[負責人手機] [nvarchar](20) NULL,
	[收款連絡人] [nvarchar](20) NULL,
	[收款連絡人電話] [nvarchar](20) NULL,
	[收款連絡人手機] [nvarchar](20) NULL,
	[拜訪連絡人] [nvarchar](20) NULL,
	[拜訪連絡人電話] [nvarchar](20) NULL,
	[拜訪連絡人手機] [nvarchar](20) NULL,
	[拜訪公司代碼] [nvarchar](20) NULL,
	[契約期間月數] [int] NULL,
	[近期帳款開立日] [char](8) NULL,
	[契約書統一編號] [nvarchar](20) NULL,
	[發票服務費] [int] NULL,
	[發票服務起日] [char](8) NULL,
	[發票服務迄日] [char](8) NULL,
	[優待月數] [int] NULL,
	[優待週期] [int] NULL,
	[優待開始日] [char](8) NULL,
	[上次優待日] [char](8) NULL,
	[郵件信箱] [nvarchar](99) NULL,
	[安裝服務費] [int] NULL,
	[安裝保證金] [int] NULL,
	[服務起日] [char](8) NULL,
	[服務迄日] [char](8) NULL,
	[暫停起日] [char](8) NULL,
	[暫停迄日] [char](8) NULL,
	[停開起日] [char](8) NULL,
	[停開迄日] [char](8) NULL,
	[解約日] [char](8) NULL,
	[備用欄位] [nvarchar](20) NULL,
	[每期發票金額] [int] NULL,
	[付款方式] [nvarchar](20) NULL,
	[合併開立] [nvarchar](20) NULL,
	[提前開立月日] [nvarchar](20) NULL,
	[特殊月份] [nvarchar](20) NULL,
	[特殊條件說明] [nvarchar](500) NULL,
	[滙款資料顯示1] [nvarchar](20) NULL,
	[滙款資料顯示2] [nvarchar](20) NULL,
	[固定虛擬帳號] [nvarchar](20) NULL,
	[暫停收費月份] [nvarchar](20) NULL,
	[erp店家代號] [nvarchar](20) NULL,
	[人工處理] [nvarchar](20) NULL,
	[備註] [nvarchar](1024) NULL,
	[收款周期] [nvarchar](99) NULL,
	[最後計費日期] [char](8) NULL,
	[租賃費加日] [char](8) NULL,
	[發票服務日期] [char](8) NULL,
	[加購開始日間] [char](8) NULL,
	[加購結束日間] [char](8) NULL,
	[RD欄位] [nvarchar](100) NULL,
	[指定列印代碼] [nvarchar](20) NULL,
	num_pos   bigint         not          NULL,
------------------------------------------------
num    bigint IDENTITY(1,1)   NOT NULL,
flowflag      char(50)            null,--流程旗標
menuflag      char(20)            null,--選單旗標自身
chjernoi      nvarchar(99)        null,--建檔資訊自身
chjernou      nvarchar(99)        null,--修改資訊自身
chjernoc      nvarchar(99)        null,--結案資訊
chjernop      nvarchar(99)        null,--過帳資訊
chjernov      nvarchar(99)        null,--作廢資訊
chjernoz      nvarchar(99)        null,--核准資訊
remark        nvarchar(max)        null,--備註說明自身
constraint pk_pos_log_num  primary key ( num  )  
)
 
GO 
CREATE unique INDEX in_pos_log_num      ON pos_log (  num        )
CREATE        INDEX in_pos_log_契約狀態 ON pos_log ( 契約狀態   )
CREATE        INDEX in_pos_log_menuflag ON pos_log ( menuflag   )
GO

 