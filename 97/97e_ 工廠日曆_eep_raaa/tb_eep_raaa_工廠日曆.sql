--USE cfp
--GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_raaa]') AND type in (N'U'))
   DROP TABLE  eep_raaa
GO
--工廠日曆
CREATE TABLE eep_raaa(
num   bigint IDENTITY(1,1)   not null,--主流水號
yyyy         int                 null,--年度   
wk           int                 null,--周次
dw           nvarchar(08)        null,--星期 
dt           datetime        not null,--日期
swt          char(01)            null,--放假
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_raaa_dt primary key ( dt )  
)
GO 
CREATE unique INDEX in_eep_raaa_num      ON eep_raaa  ( num  )
CREATE        INDEX in_eep_raaa_menuflag ON eep_raaa  ( menuflag )
GO
 