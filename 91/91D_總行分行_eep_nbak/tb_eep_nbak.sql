--USE cfp
--GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_nbak]') AND type in (N'U'))
   DROP TABLE [dbo].[eep_nbak]
GO
CREATE TABLE [dbo].[eep_nbak](
num          bigint  IDENTITY(1,1) NOT NULL,
bankcode     nvarchar(08)    not  null,--總行代碼
banknm       nvarchar(96)         null,--總行名稱
bankcode2    nvarchar(08)    not  null,--分行代碼
bankna       nvarchar(96)         null,--分行名稱
flowflag     char(50)             null,--流程旗標
menuflag     char(20)             null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)         null,--備註說明
constraint pk_eep_nbak_bankcode_bankcode2 primary key ( bankcode,bankcode2 )  
)
GO 
CREATE unique INDEX in_eep_nbak_num       ON eep_nbak ( num  )
CREATE        INDEX in_eep_nbak_menulfag  ON eep_nbak ( menuflag )
GO
 