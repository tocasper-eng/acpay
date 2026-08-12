use acpay
go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_tdh]') AND type in (N'U'))
   DROP TABLE  eep_tdh
GO
--主檔
CREATE TABLE eep_tdh(
num   bigint IDENTITY(1,1)    not null,--主流水號上對下
tdno          char(10)        not null,--單據編號上對下
tdtype        char(20)            null,--單據類別上對下 
tdno2         nvarchar(30)    not null,--相關編號上對下
tddate        datetime        not null,--單據日期上對下
zoomno        nvarchar(20)        null,--專案編號上對下
emplno        nvarchar(20)        null,--員工代碼上對下
emplnm        nvarchar(50)        null,--員工名稱上對下
plantno       nvarchar(20)        null,--工廠代碼上對下  
plantnm       nvarchar(50)        null,--工廠名稱上對下  
------------------------------------------------
flowflag      char(50)            null,--流程旗標
menuflag      char(20)            null,--選單旗標自身
chjernoi      nvarchar(99)        null,--建檔資訊自身
chjernou      nvarchar(99)        null,--修改資訊自身
chjernoc      nvarchar(99)        null,--結案資訊
chjernop      nvarchar(99)        null,--過帳資訊
chjernov      nvarchar(99)        null,--作廢資訊
chjernoz      nvarchar(99)        null,--核准資訊
remark        nvarchar(96)        null,--備註說明自身
constraint pk_eep_tdh_tdno primary key ( tdno )  
)
GO 
CREATE        INDEX in_eep_tdh_menuflag ON eep_tdh ( menuflag )
CREATE unique INDEX in_eep_tdh_num      ON eep_tdh ( num      )

GO
 