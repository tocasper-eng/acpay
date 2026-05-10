--USE cfp 
--GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_fact]') AND type in (N'U'))
   DROP TABLE  eep_fact
GO
--廠商資料
CREATE TABLE eep_fact(
num   bigint  IDENTITY(1,1)  not null,--主流水號
factno       char(08)        not null,--廠商編號
factnm       nvarchar(96)        null,--廠商名稱
kindno       nvarchar(20)        null,--廠商類別
number       nvarchar(20)        null,--統一編號
emplno       char(08)            null,--採購人員
emplnm       nvarchar(96)        null,--採購人名
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_fact_factno primary key (factno )  
)
GO 
CREATE unique INDEX in_eep_fact_nun      ON eep_fact  ( num )
CREATE 　　　 INDEX in_eep_fact_menuflag ON eep_fact  ( menuflag )
CREATE 　　　 INDEX in_eep_fact_emplno   ON eep_fact  ( emplno   )
CREATE 　　　 INDEX in_eep_fact_kindno   ON eep_fact  ( kindno   )
GO
 