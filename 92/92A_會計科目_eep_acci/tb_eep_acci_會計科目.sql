--USE cfp
--GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_acci]') AND type in (N'U'))
   DROP TABLE  eep_acci
GO
--會計科目
CREATE TABLE eep_acci(
num   bigint  IDENTITY(1,1)  not null,--主流水號
accino1      char(01)            null,--一碼科目
accinm1      nvarchar(96)        null,--一碼名稱
accino2      char(02)            null,--二碼科目
accinm2      nvarchar(96)        null,--二碼名稱
accino3      char(03)            null,--三碼科目
accinm3      nvarchar(96)        null,--三碼名稱
accino4      char(04)            null,--四碼科目
accinm4      nvarchar(96)        null,--四碼名稱
accino5      char(05)            null,--五碼科目
accinm5      nvarchar(96)        null,--五碼名稱
accino       char(06)        not null,--會計科目
accinm       nvarchar(96)        null,--科目名稱
di           char(02)            null,--關聯
cd           char(01)            null,--CD
dc           char(02)            null,--BS/IS
m54p         char(01)            null,--費用科目
m44p         char(01)            null,--收入科目
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_acci_accino primary key ( accino )  
) 
GO 
CREATE unique INDEX in_eep_acci_num  ON eep_acci  ( num    )
CREATE        INDEX in_eep_acci_menuflag ON eep_acci  ( menuflag )
GO
 