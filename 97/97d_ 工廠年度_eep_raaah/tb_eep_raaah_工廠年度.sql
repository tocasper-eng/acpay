--USE cfp
--GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_raaah]') AND type in (N'U'))
   DROP TABLE  eep_raaah
GO
--工廠年度
CREATE TABLE eep_raaah(
num   bigint  IDENTITY(1,1)  not null,--主流水號
yyyy           int           not null,--工廠年度
--wk1          nvarchar(20)        null,--周一
--wk2          nvarchar(20)        null,--周二
--wk3          nvarchar(20)        null,--周三
--wk4          nvarchar(20)        null,--周四
--wk5          nvarchar(20)        null,--周五
--wk6          nvarchar(20)        null,--周六
--wk7          nvarchar(20)        null,--周日 
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_raaah_yyyy primary key ( yyyy )  
)
GO 
CREATE unique INDEX in_eep_raaah_num      ON eep_raaah  ( num  )
CREATE        INDEX in_eep_raaah_menuflag ON eep_raaah  ( menuflag )
GO
 