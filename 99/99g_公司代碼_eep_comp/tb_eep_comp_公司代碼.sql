--USE cfp
--GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_comp]') AND type in (N'U'))
   DROP TABLE  eep_comp
GO
--公司代碼
CREATE TABLE eep_comp(
num   bigint  IDENTITY(1,1)  not null,--主流水號
compno       nvarchar(96)    not null,--公司代碼
compnm       nvarchar(96)        null,--公司名稱
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_comp_compno primary key ( compno )  
)
GO 
CREATE unique INDEX in_eep_comp_num       ON eep_comp  ( num )
CREATE        INDEX in_eep_comp_menuflag  ON eep_comp  ( menuflag )
GO
 