use acpay
go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_tdd]') AND type in (N'U'))
   DROP TABLE  eep_tdd
GO
--明細
CREATE TABLE eep_tdd(
num   bigint IDENTITY(1,1)    not null,--主流水號
tdno          char(10)        not null,--單據編號
tdseq         char(20)        not null,--項次
itemno        nvarchar(20)        null,--物料代碼
itemnm        nvarchar(50)        null,--物料名稱
specnm        nvarchar(50)        null,--物料規格
unitno        char(04)            null,--單位
warenofm      char(08)            null,--撥出倉庫
warenmfm      nvarchar(20)        null,--撥出倉名
warenoto      char(08)            null,--撥入倉庫
warenmto      nvarchar(20)        null,--撥入倉名
tdqty         int                 null,--數量
-------------------------------------------------------
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
constraint pk_eep_tdd_tdno_tdseq  primary key ( tdno , tdseq  )  
)
GO 
CREATE        INDEX in_eep_tdd_menuflag ON eep_tdd ( menuflag )
CREATE unique INDEX in_eep_tdd_num      ON eep_tdd ( num      )

GO
 