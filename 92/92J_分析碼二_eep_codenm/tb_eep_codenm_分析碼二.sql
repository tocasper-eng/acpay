--use cfp
--go
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_codenm]') AND type in (N'U'))
   DROP TABLE  eep_codenm
GO
--分析碼二
CREATE TABLE eep_codenm(
num   bigint  IDENTITY(1,1)  not null,--主流水號
codenm       nvarchar(20)    not null,--分析碼二
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_codenm_codenm primary key ( codenm )  
)
GO 
CREATE unique INDEX in_eep_codenm_num  ON eep_codenm( num   )
CREATE        INDEX in_eep_codenm_menuflag ON eep_codenm( menuflag )
GO
 