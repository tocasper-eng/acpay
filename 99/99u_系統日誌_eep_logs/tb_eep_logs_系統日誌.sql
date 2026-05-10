--USE cfp
--GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_logs]') AND type in (N'U'))
   DROP TABLE  eep_logs
GO
--系統日誌
CREATE TABLE eep_logs(
num   bigint  IDENTITY(1,1)   not null,--主流水號
dt            datetime        not null,--公司代碼
flowflag      char(50)            null,--流程旗標
menuflag      char(20)            null,--選單旗標自身
chjernoi      nvarchar(99)        null,--建檔資訊自身
chjernou      nvarchar(99)        null,--修改資訊自身
chjernoc      nvarchar(99)        null,--結案資訊
chjernop      nvarchar(99)        null,--過帳資訊
chjernov      nvarchar(99)        null,--作廢資訊
chjernoz      nvarchar(99)        null --核准資訊
constraint pk_eep_logs_num  primary key ( num  )  
)
GO 
CREATE        INDEX in_eep_logs_dt        ON eep_logs  ( dt )
CREATE        INDEX in_eep_logs_menuflag  ON eep_logs  ( menuflag )
 
 