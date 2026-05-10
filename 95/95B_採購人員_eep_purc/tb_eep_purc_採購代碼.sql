--use cfp 
--go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_purc]') AND type in (N'U'))
   DROP TABLE  eep_purc
GO
--採購代碼
CREATE TABLE eep_purc(
num   bigint  IDENTITY(1,1)  not null,--主流水號
purcno       char(08)        not null,--採購代碼
purcnm       nvarchar(96)        null,--採購名稱
parent       char(08)            null,--上層主管
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
chjernov     nvarchar(99)        null,--作廢資訊
chjernop     nvarchar(99)        null,--過帳資訊
chjernod     nvarchar(99)        null,--複製資訊
chjernom     nvarchar(99)        null,--製單資訊
chjernos     nvarchar(99)        null,--審核資訊
chjernoz     nvarchar(99)        null,--核准資訊
chjernoa     nvarchar(99)        null,--採立資訊
chjernoe     nvarchar(99)        null,--立帳資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_purc_purcno primary key ( purcno )  
)
GO 
CREATE unique INDEX in_eep_purc_num      ON eep_purc  ( num   )
CREATE        INDEX in_eep_purc_menuflag ON eep_purc  ( menuflag )
CREATE        INDEX in_eep_purc_parent   ON eep_purc  ( parent )
GO