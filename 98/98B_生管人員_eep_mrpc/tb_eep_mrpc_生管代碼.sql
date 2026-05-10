--use cfp 
--go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_mrpc]') AND type in (N'U'))
   DROP TABLE  eep_mrpc
GO
--生管代碼
CREATE TABLE eep_mrpc(
num   bigint  IDENTITY(1,1)  not null,--主流水號
mrpcno       char(08)        not null,--生管代碼
mrpcnm       nvarchar(96)        null,--生管名稱
parent       char(08)            null,--上層主管
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_mrpc_mrpcno primary key ( mrpcno )  
)
GO 
CREATE unique INDEX in_eep_mrpc_num      ON eep_mrpc  ( num   )
CREATE        INDEX in_eep_mrpc_menuflag ON eep_mrpc  ( menuflag )
CREATE        INDEX in_eep_mrpc_parent   ON eep_mrpc  ( parent )
GO