--use cfp 
--go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_sale]') AND type in (N'U'))
   DROP TABLE  eep_sale
GO
--業務代碼
CREATE TABLE eep_sale(
num   bigint  IDENTITY(1,1)  not null,--主流水號
saleno       char(08)        not null,--業務代碼
salenm       nvarchar(96)        null,--業務名稱
parent       char(08)            null,--上層主管
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_sale_saleno primary key ( saleno )  
)
GO 
CREATE unique INDEX in_eep_sale_num      ON eep_sale  ( num   )
CREATE        INDEX in_eep_sale_menuflag ON eep_sale  ( menuflag )
CREATE        INDEX in_eep_sale_parent   ON eep_sale  ( parent )
GO