use acpay
go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_uuh]') AND type in (N'U'))
   DROP TABLE  eep_uuh
GO 
--回報主檔
CREATE TABLE eep_uuh(
num   bigint IDENTITY(1,1)      not null,--主流水號上對下
wuno            char(20)        not null,--回報編號
wudate          datetime        not null,--回報主檔
emplno          char(08)            null,--回報人員
emplnm          nvarchar(20)        null,--回報人員
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
constraint pk_eep_uuh_wuno primary key ( wuno )  
)
GO 
CREATE        INDEX in_eep_uuh_menuflag ON eep_uuh ( menuflag )
CREATE unique INDEX in_eep_uuh_num      ON eep_uuh ( num      )

GO
 