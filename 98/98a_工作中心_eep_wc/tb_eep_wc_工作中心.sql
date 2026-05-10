--USE cfp 
--GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_wc]') AND type in (N'U'))
   DROP TABLE  eep_wc
GO
--產線代碼
CREATE TABLE eep_wc(
num   bigint  IDENTITY(1,1)  not null,--主流水號
wcno         char(08)        not null,--產線代碼
wcnm         nvarchar(96)        null,--產線名稱
depano       char(06)            null,--部門代碼
depanm       nvarchar(96)        null,--部門名稱
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark        nvarchar(96)       null,--備註說明
constraint pk_eep_wc_wcno primary key ( wcno )  
)
GO 
CREATE unique INDEX in_eep_wc_num     ON eep_wc  ( num   )
CREATE        INDEX in_eep_wc_depano   ON eep_wc  ( depano )
CREATE        INDEX in_eep_wc_menuflag ON eep_wc  ( menuflag )
GO
 