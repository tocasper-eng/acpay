--USE cfp 
--GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_ieno]') AND type in (N'U'))
   DROP TABLE  eep_ieno
GO
--製程代碼
CREATE TABLE eep_ieno(
num   bigint  IDENTITY(1,1)  not null,--主流水號
ienono         char(08)      not null,--製程代碼
ienonm         nvarchar(96)      null,--製程名稱
wcno           char(08)      not null,--產線代碼
wcnm           nvarchar(96)      null,--產線名稱
flowflag       char(50)          null,--流程旗標
menuflag       char(20)          null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark         nvarchar(96)      null,--備註說明
constraint pk_eep_ieno_ienono primary key ( ienono )  
)
GO 
CREATE unique INDEX in_eep_ieno_num      ON eep_ieno ( num      )
CREATE        INDEX in_eep_ieno_wcno     ON eep_ieno ( wcno     )
CREATE        INDEX in_eep_ieno_menuflag ON eep_ieno ( menuflag )
GO
 