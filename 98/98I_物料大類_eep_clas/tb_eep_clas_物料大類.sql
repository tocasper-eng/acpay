use acpay
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_clas]') AND type in (N'U'))
   DROP TABLE  eep_clas
GO
--物料大類
CREATE TABLE eep_clas(
num   bigint   IDENTITY(1,1)   not null,--主流水號
swt            nvarchar(20)    not null,--庫存管制
fg             nvarchar(20)        null,--存貨大類
clasno         char(08)        not null,--物料大類
clasnm         nvarchar(96)        null,--大類名稱
flowflag       char(50)            null,--流程旗標
menuflag       char(20)            null,--選單旗標
chjernoi     nvarchar(99)          null,--建檔資訊
chjernou     nvarchar(99)          null,--修改資訊
remark         nvarchar(96)        null,--備註說明
constraint pk_eep_clas_clasno primary key ( clasno )  
)
GO 
CREATE unique INDEX in_clas_num      ON eep_clas  ( num  )
CREATE        INDEX in_clas_menuflag ON eep_clas  ( menuflag )
GO
 