use acpay
go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pos_tod]') AND type in (N'U'))
   DROP TABLE  pos_tod
GO
--select * from pos_tod

--明細
CREATE TABLE pos_tod(
num   bigint IDENTITY(1,1)    not null,--主流水號
tono          char(10)        not null,--單據編號
toseq         char(20)        not null,--項次
itemno        nvarchar(20)        null,--物料代碼
itemnm        nvarchar(50)        null,--物料名稱
specnm        nvarchar(50)        null,--物料規格
unitno        char(04)            null,--單位
clasno        nvarchar(20)        null,--類別代碼
clasnm        nvarchar(20)        null,--類別名稱
wareno        char(08)            null,--倉庫代碼
warenm        nvarchar(20)        null,--倉庫名稱
toqty         int                 null,--數量
------------------------------------------------------
totype        char(20)            null,--單據類別上對下 
tono2         nvarchar(30)    not null,--相關編號上對下
todate        datetime        not null,--單據日期上對下
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
itemna        nvarchar(96)        null,
toamt         decimal(18,2)       null
constraint pk_pos_tod_tono_trseq  primary key ( tono , toseq  )  
)
GO 
CREATE        INDEX in_pos_tod_menuflag ON pos_tod ( menuflag )
CREATE unique INDEX in_pos_tod_num      ON pos_tod ( num      )

GO
 
 
 delete eep_tod 

 select * from eep_tod 

 select * from mes_itio where ioseqseq = 'TDD+'
select * from mes_itio where ioseqseq = 'TDD-'
UPDATE pos_tod set zoomno = 'x' 
