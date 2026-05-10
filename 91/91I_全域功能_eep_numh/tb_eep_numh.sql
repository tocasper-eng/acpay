--USE cfp
--GO
--alter table eep_numh drop column linktable 
--alter table eep_numh add linknumber   nvarchar(20)         null,--連結編號
--alter table eep_numh add linkaction   nvarchar(100)        null,--連結動作

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_numh]') AND type in (N'U'))
   DROP TABLE [dbo].[eep_numh]
GO
CREATE TABLE [dbo].[eep_numh](
num          bigint  IDENTITY(1,1) NOT NULL,
menunum      nvarchar(20)    not  NULL,--選單代碼
fieldno      nvarchar(20)    not  NULL,--欄位名稱
remark       nvarchar(100)        NULL,--備註說明 
linknumber   nvarchar(20)         null,--連結編號
linkaction   nvarchar(100)        null,--連結動作
flowflag     char(50)             null,--流程旗標
menuflag     char(20)             null,--選單旗標
chjernoi     nvarchar(99)         null,--建檔資訊
chjernou     nvarchar(99)         null,--修改資訊
 
constraint pk_eep_numh_menunum_fieldno primary key ( menunum ,  fieldno  )  
)
GO 
CREATE unique INDEX in_eep_numh_num          ON eep_numh ( num   )
CREATE        INDEX in_eep_numh_menulfag     ON eep_numh ( menuflag )
CREATE        INDEX in_eep_numh_menunum      ON eep_numh ( menunum  )
CREATE        INDEX in_eep_numh_fieldno      ON eep_numh ( fieldno  )
CREATE        INDEX in_eep_numh_linknumber   ON eep_numh ( linknumber  )
GO