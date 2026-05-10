--USE cfp
--GO
--alter table eep_menu add linknumber   nvarchar(20)         null,--連結編號
--alter table eep_menu drop column linktable 

--alter table eep_menu add linkaction   nvarchar(100)        null,--連結動作
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_menu]') AND type in (N'U'))
   DROP TABLE [dbo].[eep_menu]
GO
CREATE TABLE [dbo].[eep_menu](
num          bigint  IDENTITY(1,1) NOT NULL,
menunum      nvarchar(20)    not  NULL,--選單代碼
remark       nvarchar(100)        NULL,--備註說明 
linknumber   nvarchar(20)         null,--連結編號
linkaction   nvarchar(100)        null,--連結動作
flowflag     char(50)             null,--流程旗標
menuflag     char(20)             null,--選單旗標
chjernoi     nvarchar(99)         null,--建檔資訊
chjernou     nvarchar(99)         null,--修改資訊

constraint pk_eep_menu_menunum_tableno primary key ( menunum   )  
)
GO 
CREATE unique INDEX in_eep_menu_num         ON eep_menu ( num      )
CREATE        INDEX in_eep_menu_menulfag    ON eep_menu ( menuflag )
CREATE        INDEX in_eep_menu_linknumber  ON eep_menu ( linknumber )
 
 
GO