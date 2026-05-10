--use cfp 
--go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_puorg]') AND type in (N'U'))
   DROP TABLE  eep_puorg
GO
--客戶代碼
CREATE TABLE eep_puorg(
num   bigint  IDENTITY(1,1)   not null,--主流水號
puorgno       char(08)        not null,--採購組織
puorgnm       nvarchar(20)        null,--組織名稱
compno        nvarchar(96)    not null,--公司代碼
compnm        nvarchar(96)        null,--公司名稱
emplno        char(08)            null,--員工編號
emplnm        nvarchar(20)        null,--員工名稱
swt           char(01)            null,--預設旗標
flowflag      char(50)            null,--流程旗標
menuflag      char(20)            null,--選單旗標
chjernoi      nvarchar(99)        null,--建檔資訊
chjernou      nvarchar(99)        null,--修改資訊
remark        nvarchar(96)        null,--備註說明
constraint pk_eep_puorg_puorgno  primary key ( puorgno)  
)
GO 
CREATE unique INDEX in_eep_puorg_num   ON eep_puorg  ( num  )
CREATE 　　　 INDEX in_eep_puorg_menuflag ON eep_puorg  ( menuflag )
GO
 