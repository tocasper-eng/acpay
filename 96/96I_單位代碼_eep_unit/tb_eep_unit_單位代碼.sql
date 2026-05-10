--use cfp
--go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_unit]') AND type in (N'U'))
   DROP TABLE  eep_unit
GO
--單位代碼
CREATE TABLE eep_unit(
num   bigint  IDENTITY(1,1)  not null,--主流水號
unitno       char(08)        not null,--原始代碼
unitno2      char(08)        not null,--換算代碼
unitrate     decimal(20,4)       null,--換算比率
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_unit_unitno_unitno2 primary key ( unitno,unitno2 )  
)
GO 
CREATE unique INDEX in_unit_num ON eep_unit  ( num  )
CREATE        INDEX in_unit_menuflag       ON eep_unit  ( menuflag       )
GO
 