--USE cfp
--GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_nban]') AND type in (N'U'))
   DROP TABLE [dbo].[eep_nban]
GO
CREATE TABLE [dbo].[eep_nban](
num          bigint  IDENTITY(1,1) NOT NULL,
bankno       char(08)        not  NULL,--幣別代碼
banknm       nvarchar(96)         NULL,--幣別名稱
flowflag     char(50)             null,--流程旗標
menuflag     char(20)             null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)         null,--備註說明
constraint pk_eep_nban_bankno primary key ( bankno )  
)
GO 
CREATE unique INDEX in_eep_nban_num       ON eep_nban ( num   )
CREATE        INDEX in_eep_nban_menulfag  ON eep_nban ( menuflag )
GO