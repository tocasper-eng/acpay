--use cfp 
--go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_addp]') AND type in (N'U'))
   DROP TABLE  eep_addp 
GO
--廠商地址 
CREATE TABLE eep_addp(
num  bigint  IDENTITY(1,1)   not null,--主流水號
factno       char(08)        not null,--廠商代碼
factnm       nvarchar(96)        null,--廠商名稱
addpno       char(04)        not null,--項次
addrss       nvarchar(96)        null,--廠商地址
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_addp_factno_addpno  primary key ( factno,addpno)  
)
GO 
CREATE unique INDEX in_eep_addp_num ON eep_addp  ( num )
CREATE 　　　 INDEX in_eep_addp_menuflag ON eep_addp  ( menuflag )
GO
GO