--use cfp
--go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_line]') AND type in (N'U'))
   DROP TABLE  eep_line
GO
--員工編號
CREATE TABLE eep_line(
num  bigint  IDENTITY(1,1)   not null,--主流水號
linenum      nvarchar(20)    not null,--員工代碼
linenm       nvarchar(96)        null,--員工名稱
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_line_linenum primary key ( linenum )  
)
GO 
CREATE unique INDEX in_eep_line_num  ON eep_line ( num  )
CREATE        INDEX in_eep_line_menuflag ON eep_line ( menuflag )
GO
 