use acpay
go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_iwh]') AND type in (N'U'))
   DROP TABLE  eep_iwh
GO
--通知主檔
CREATE TABLE eep_iwh(
num   bigint IDENTITY(1,1)   not null,--主流水號上對下
iwno          char(20)        not null,--通知編號上對下
iwtype        char(20)            null,--通知類別    陌生客戶 / 契約客戶
iwno2         nvarchar(30)    not null,--客戶訂單上對下
iwdate        datetime        not null,--訂單日期上對下
zoomno        nvarchar(20)        null,--契約編號上對下 dddw pos.契約編號 欄位多一點
custno        nvarchar(20)        null,--客戶代碼上對下
custnm        nvarchar(50)        null,--客戶名稱上對下
address0      nvarchar(100)       null,--客戶全名
attention     nvarchar(20)        null,--來電人員
saleno        nvarchar(20)        null,--業務代碼上對下  login userid 
salenm        nvarchar(50)        null,--業務名稱上對下  login username 
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
constraint pk_eep_twh_twno primary key (iwno )  
)
GO 
CREATE        INDEX in_eep_iwh_menuflag ON eep_iwh ( menuflag )
CREATE unique INDEX in_eep_iwh_num      ON eep_iwh ( num      )

GO
 