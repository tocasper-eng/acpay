--use cfp 
--go 
--select * from eep_cust 

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_cust]') AND type in (N'U'))
   DROP TABLE  eep_cust
GO
--客戶代碼
CREATE TABLE eep_cust(
num   bigint  IDENTITY(1,1)  not null,--主流水號
custno       char(08)        not null,--客戶代碼
custnm       nvarchar(96)        null,--客戶名稱
kindno       nvarchar(20)        null,--廠商類別
number       nvarchar(20)        null,--統一編號
saleno       char(08)            null,--業務代碼
salenm       nvarchar(96)        null,--業務名稱
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_cust_custno primary key ( custno )  
)
GO 
CREATE unique INDEX in_eep_cust_num  ON eep_cust  ( num   )
CREATE 　　　 INDEX in_eep_cust_menuflag ON eep_cust  ( menuflag )
CREATE 　　　 INDEX in_eep_cust_saleno   ON eep_cust  ( saleno   )
CREATE 　　　 INDEX in_eep_cust_kindno   ON eep_cust  ( kindno   )
GO
 