use acpay
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_purp]') AND type in (N'U'))
   DROP TABLE  eep_purp
GO
--物料大類
CREATE TABLE eep_purp(
num   bigint   IDENTITY(1,1)   not null,--主流水號
purpno         char(08)        not null,--用途代碼
purpnm         nvarchar(96)        null,--用途名稱
flowflag       char(50)            null,--流程旗標
menuflag       char(20)            null,--選單旗標
chjernoi     nvarchar(99)          null,--建檔資訊
chjernou     nvarchar(99)          null,--修改資訊
remark         nvarchar(96)        null,--備註說明
constraint pk_eep_purp_purpno primary key ( purpno )  
)
GO 
CREATE unique INDEX in_purp_num      ON eep_purp  ( num  )
CREATE        INDEX in_purp_menuflag ON eep_purp  ( menuflag )
GO
 