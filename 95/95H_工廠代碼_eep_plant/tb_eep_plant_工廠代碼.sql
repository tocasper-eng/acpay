--use cfp 
--go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_plant]') AND type in (N'U'))
   DROP TABLE  eep_plant
GO
--客戶代碼
CREATE TABLE eep_plant(
num   bigint  IDENTITY(1,1)   not null,--主流水號
plantno       char(08)        not null,--工廠代碼
plantnm       nvarchar(96)        null,--工廠名稱
compno        nvarchar(96)    not null,--公司代碼
compnm        nvarchar(96)        null,--公司名稱
flowflag      char(50)            null,--流程旗標
menuflag      char(20)            null,--選單旗標
chjernoi      nvarchar(99)        null,--建檔資訊
chjernou      nvarchar(99)        null,--修改資訊
remark        nvarchar(96)        null,--備註說明
constraint pk_eep_plant_plantno  primary key ( plantno)  
)
GO 
CREATE unique INDEX in_eep_plant_num   ON eep_plant  ( num  )
CREATE 　　　 INDEX in_eep_plant_menuflag ON eep_plant  ( menuflag )
GO
 