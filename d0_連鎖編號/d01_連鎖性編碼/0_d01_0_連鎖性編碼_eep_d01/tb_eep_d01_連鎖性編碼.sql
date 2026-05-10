use acpay
go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_d01]') AND type in (N'U'))
   DROP TABLE  eep_d01
GO 
--新案建檔
CREATE TABLE eep_d01(
連鎖性客戶編號	 NVARCHAR(20),--Y
連鎖性客戶名稱	 NVARCHAR(99),--Z
remark           nvarchar(96)        null,--備註說明 
 
 ------------------------------------------------
flowflag      char(50)            null,--流程旗標
menuflag      char(20)            null,--選單旗標自身
chjernoi      nvarchar(99)        null,--建檔資訊自身
chjernou      nvarchar(99)        null,--修改資訊自身
chjernoc      nvarchar(99)        null,--結案資訊
chjernop      nvarchar(99)        null,--過帳資訊
chjernov      nvarchar(99)        null,--作廢資訊
chjernoz      nvarchar(99)        null,--核准資訊

num bigint identity(1,1)  not null, 
constraint pk_eep_d01_num  primary key ( num )  
)
GO 
CREATE        INDEX in_eep_d01_menuflag       ON eep_d01 ( menuflag )
CREATE unique INDEX in_eep_d01_連鎖性客戶編號 ON eep_d01 ( 連鎖性客戶編號 )
 