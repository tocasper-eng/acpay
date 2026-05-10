--USE cfp
--GO
alter table eep_empl alter column linenum      nvarchar(20)            null--班組代碼
alter table eep_empl add emplnn       nvarchar(96)        null --英文名稱

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_empl]') AND type in (N'U'))
   DROP TABLE  eep_empl
GO
--員工編號
CREATE TABLE eep_empl(
num   bigint  IDENTITY(1,1)  not null,--主流水號
emplno       char(08)        not null,--員工代碼
emplnm       nvarchar(96)        null,--員工名稱
emplnn       nvarchar(96)        null,--英文名稱
depano       char(06)            null,--部門代碼
depanm       nvarchar(96)        null,--部門名稱
jobsno       char(06)            null,--職位代碼
jobsnm       nvarchar(96)        null,--職位名稱
linenum      nvarchar(20)        null,--班組代碼
linenm       nvarchar(96)        null,--班組名稱
telno        nvarchar(30)        null,--連絡電話
bbc          nvarchar(30)        NULL,--連絡手機
email        nvarchar(30)        null,--電子郵件
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_empl_emplno primary key ( emplno )  
)
GO 
CREATE unique INDEX in_eep_empl_num  ON eep_empl  ( num  )
CREATE        INDEX in_eep_empl_menuflag ON eep_empl  ( menuflag )
GO
 