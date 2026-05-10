--USE cfp
--GO
--alter table eep_num8 add linknumber   nvarchar(20)         null,--連結編號
--alter table eep_num8 add linkaction   nvarchar(100)        null,--連結動作

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_num8]') AND type in (N'U'))
   DROP TABLE [dbo].[eep_num8]
GO
CREATE TABLE [dbo].[eep_num8](
num          bigint  IDENTITY(1,1) NOT NULL,
menunum      nvarchar(20)    not  NULL,--選單代碼
fieldno      nvarchar(20)    not  NULL,--欄位名稱
dddwno       nvarchar(100)   not  NULL,--片語代碼
dddwnm       nvarchar(100)   not  NULL,--片語名稱
linknumber   nvarchar(20)         null,--連結編號
linkaction   nvarchar(100)        null,--連結動作
remark       nvarchar(100)        NULL,--備註說明 
flowflag     char(50)             null,--流程旗標
menuflag     char(20)             null,--選單旗標
chjernoi     nvarchar(99)         null,--建檔資訊
chjernou     nvarchar(99)         null,--修改資訊 
constraint pk_eep_num8_menunum_fieldno_dddwno_dddwnm primary key ( menunum, fieldno, dddwno, dddwnm )  
)
GO 
CREATE unique INDEX in_eep_num8_num         ON eep_num8 ( num   )
CREATE        INDEX in_eep_num8_menulfag    ON eep_num8 ( menuflag )
CREATE        INDEX in_eep_num8_dddwno      ON eep_num8 ( dddwno )
CREATE        INDEX in_eep_num8_fieldno     ON eep_num8 ( fieldno  )
CREATE        INDEX in_eep_num8_dddwnm      ON eep_num8 ( dddwnm  )
CREATE        INDEX in_eep_num8_linknumber  ON eep_menu ( linknumber )
 
 
GO