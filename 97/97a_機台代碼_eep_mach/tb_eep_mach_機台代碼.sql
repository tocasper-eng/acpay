--USE cfp
--GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_mach]') AND type in (N'U'))
   DROP TABLE  eep_mach
GO
--機台代碼
CREATE TABLE eep_mach(
num   bigint  IDENTITY(1,1)  not null,--主流水號
machno       char(08)        not null,--機台代碼
machnm       nvarchar(96)        null,--機台名稱
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_mach_machno primary key ( machno )  
)
GO 
CREATE unique INDEX in_eep_mach_num  ON eep_mach  ( num  )
CREATE        INDEX in_eep_mach_menuflag ON eep_mach  ( menuflag )
GO
 