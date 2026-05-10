use acpay
go 

--alter table eep_pos add 來源契約編號	 NVARCHAR(20) 
--alter table eep_pos add 正式契約編號	 NVARCHAR(20)
--alter table eep_pos add 契約狀態	     NVARCHAR(20)


 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_pos]') AND type in (N'U'))
   DROP TABLE  eep_pos
GO 
--新案建檔
CREATE TABLE eep_pos(
契約狀態	     NVARCHAR(20),   --A
部門代碼	     NVARCHAR(20),  --B 
部門名稱	     NVARCHAR(20),  --C 
公司代碼	     NVARCHAR(20),  --D 
公司名稱	     NVARCHAR(20),  --E 
來源契約編號	 NVARCHAR(20),  --F 
正式契約編號	 NVARCHAR(20),  --F 
客戶發票抬頭     NVARCHAR(99),  --G 	
狀況代碼	     NVARCHAR(20),  --H 
狀況開通	     NVARCHAR(20),  --I 
營業員編號       NVARCHAR(20), --J 
營業員名稱       NVARCHAR(20), --K 
--成約日期	     CHAR(08), --L 
--開通日期	     CHAR(08),  --M 
系統別	         NVARCHAR(20), --N 
系統別名稱	     NVARCHAR(20), --O 
契約書客戶名稱	 NVARCHAR(99), --P
--成約租賃費	     INT,--Q
--契約保證金	     INT,--R
--收款週期	     INT,--S
--最後計費日	     CHAR(08),--T
客戶發票地址	 NVARCHAR(99),--U
標的物名稱	     NVARCHAR(99),--V
標的物地址	     NVARCHAR(99),--W
客戶統編	     nvarCHAR(20),--X
連鎖性客戶編號	 NVARCHAR(20),--Y
連鎖性客戶名稱	 NVARCHAR(99),--Z
負責人	         NVARCHAR(20),--AA
負責人電話	     NVARCHAR(20),--AB
負責人手機	     NVARCHAR(20),--AC
收款連絡人	     NVARCHAR(20),--AD
收款連絡人電話	 NVARCHAR(20),--AE
收款連絡人手機	 NVARCHAR(20),--AF
拜訪連絡人	     NVARCHAR(20),--AG
拜訪連絡人電話	 NVARCHAR(20),--AH
拜訪連絡人手機	 NVARCHAR(20),--AI
拜訪公司代碼	 NVARCHAR(20),--AJ
--契約期間月數     INT,--AK  
--近期帳款開立日	 CHAR(08),--AL
--契約書統一編號	 NVARCHAR(20),--AM
--發票服務費	     INT,--AN
--發票服務起日	 CHAR(08),--AO
--發票服務迄日	 CHAR(08),--AP
--優待月數	     INT,--AQ
--優待週期	     INT,--AR
--優待開始日	     CHAR(08),--AS
--上次優待日	     CHAR(08),--AT
--郵件信箱	     NVARCHAR(99),--AU
--安裝服務費	     INT,--AV
--安裝保證金	     INT,--AW
--服務起日	     CHAR(08),--AX
--服務迄日	     CHAR(08),--AY
--暫停起日	     CHAR(08),--AZ
--暫停迄日	     CHAR(08),--BA
--停開起日	     CHAR(08),--BB
--停開迄日	     CHAR(08),--BC
--解約日	         CHAR(08),--BD
--備用欄位	     NVARCHAR(20),--BE
--每期發票金額	 INT,--BF
--付款方式	     NVARCHAR(20),--BG
--合併開立	     NVARCHAR(20),--BH
--提前開立月日	 NVARCHAR(20),--BI
--特殊月份	     NVARCHAR(20),--BJ
--特殊條件說明	 NVARCHAR(500),--BK
--滙款資料顯示1	 NVARCHAR(20),--BL
--滙款資料顯示2	 NVARCHAR(20),--BM
--固定虛擬帳號	 NVARCHAR(20),--BN
--暫停收費月份	 NVARCHAR(20),--BO
--erp店家代號	     NVARCHAR(20),--BP
--人工處理	     NVARCHAR(20),--BQ
--備註	         NVARCHAR(99),--BR
--收款周期	     NVARCHAR(99),--BS
--最後計費日期     CHAR(08),--BT
--租賃費加日	     CHAR(08),--BU
--發票服務日期	 CHAR(08),--BV
--加購開始日間	 CHAR(08),--BW
--加購結束日間	 CHAR(08),--BX
--RD欄位	         NVARCHAR(100),--BY
--指定列印代碼     NVARCHAR(20),--BZ

 ------------------------------------------------
flowflag      char(50)            null,--流程旗標
menuflag      char(20)            null,--選單旗標自身
chjernoi      nvarchar(99)        null,--建檔資訊自身
chjernou      nvarchar(99)        null,--修改資訊自身
chjernoc      nvarchar(99)        null,--結案資訊
chjernop      nvarchar(99)        null,--過帳資訊
chjernov      nvarchar(99)        null,--作廢資訊
chjernoz      nvarchar(99)        null,--核准資訊
remark        nvarchar(96)        null,--備註說明自身

num bigint identity(1,1)  not null, 
constraint pk_eep_pos_num  primary key ( num )  
)
GO 
CREATE        INDEX in_eep_pos_menuflag ON eep_pos ( menuflag )

 