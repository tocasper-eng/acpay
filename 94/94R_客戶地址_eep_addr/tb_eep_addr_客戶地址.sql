--use cfp 
--go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_addr]') AND type in (N'U'))
   DROP TABLE  eep_addr 
GO
--客戶代碼
CREATE TABLE eep_addr(
num  bigint  IDENTITY(1,1)   not null,--主流水號
custno       char(08)        not null,--客戶代碼
custnm       nvarchar(96)        null,--客戶名稱
addrno       char(04)        not null,--項次
addrss       nvarchar(96)        null,--客戶地址
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_addr_custno_addrno primary key ( custno,addrno )  
)
GO 
CREATE unique INDEX in_eep_addr_num ON eep_addr  ( num  )
CREATE 　　　 INDEX in_eep_addr_menuflag ON eep_addr  ( menuflag )
GO
GO