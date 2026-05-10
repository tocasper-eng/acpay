--USE cfp
--GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_curr]') AND type in (N'U'))
   DROP TABLE [dbo].[eep_curr]
GO
CREATE TABLE [dbo].[eep_curr](
num          bigint  IDENTITY(1,1) NOT NULL,
currno       char(03)       not   NULL,--幣別代碼
currnm       nvarchar(96)         NULL,--幣別名稱
flowflag     char(50)             null,--流程旗標
menuflag     char(20)             null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)         null,--備註說明
constraint pk_eep_curr_currno primary key ( currno )  
)
GO 
CREATE unique INDEX in_eep_curr_num    ON eep_curr ( num   )
CREATE        INDEX in_eep_curr_menulfag  ON eep_curr ( menuflag )
GO