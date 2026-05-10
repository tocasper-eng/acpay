use acpay
go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_uud]') AND type in (N'U'))
   DROP TABLE  eep_uud
GO 
--回報明細
CREATE TABLE eep_uud(
num   bigint IDENTITY(1,1)      not null,--主流水號上對下
wuno            char(20)        not null,--回報編號
seq             char(04)        not null,--項次
ienono          char(08)            null,--作業類別
ienonm          nvarchar(20)        null,--作業名稱 
hrs             decimal(10,1)       null,--作業時數 
---------------------------------------------------
flowflag      char(50)            null,--流程旗標
menuflag      char(20)            null,--選單旗標自身
chjernoi      nvarchar(99)        null,--建檔資訊自身
chjernou      nvarchar(99)        null,--修改資訊自身
chjernoc      nvarchar(99)        null,--結案資訊
chjernop      nvarchar(99)        null,--過帳資訊
chjernov      nvarchar(99)        null,--作廢資訊
chjernoz      nvarchar(99)        null,--核准資訊
remark        nvarchar(96)        null,--備註說明自身
constraint pk_eep_uud_wuno primary key ( wuno )  
)
GO 
CREATE        INDEX in_eep_uud_menuflag ON eep_uud ( menuflag )
CREATE unique INDEX in_eep_uud_num      ON eep_uud ( num      )

GO
 