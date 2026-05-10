--USE cfp
--GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_xdur]') AND type in (N'U'))
   DROP TABLE  eep_xdur
GO
--考勤代碼
CREATE TABLE eep_xdur(
num   bigint  IDENTITY(1,1)  not null,--主流水號
xdurno       char(08)        not null,--考勤代碼
xdurnm       nvarchar(96)        null,--考勤名稱
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_xdur_xdurno primary key ( xdurno )  
)
GO 
CREATE unique INDEX in_eep_xdur_num  ON eep_xdur ( num   )
CREATE        INDEX in_eep_xdur_menuflag ON eep_xdur ( menuflag )
GO
 