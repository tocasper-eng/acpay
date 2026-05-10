--USE cfp
--GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_sono2]') AND type in (N'U'))
   DROP TABLE [dbo].[eep_sono2]
GO
CREATE TABLE [dbo].[eep_sono2](
num   bigint IDENTITY(1,1)   NOT NULL,--主流水號
sono2        nvarchar(96)    not NULL,--專案名稱
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_sono2_sono2  primary key ( sono2  )  
)
GO 
CREATE unique INDEX in_eep_sono2_num       ON eep_sono2 ( num      )
CREATE        INDEX in_eep_sono2_menulfag  ON eep_sono2 ( menuflag )

GO
 