--USE cfp
--GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_jobs]') AND type in (N'U'))
   DROP TABLE  eep_jobs
GO
--職務代碼
CREATE TABLE eep_jobs(
num   bigint  IDENTITY(1,1)  not null,--主流水號
jobsno       char(08)        not null,--職務代碼
jobsnm       nvarchar(96)        null,--職務名稱
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_jobs_jobsno primary key ( jobsno )  
)
GO 
CREATE unique INDEX in_eep_jobs_num  ON eep_jobs ( num  )
CREATE        INDEX in_eep_jobs_menuflag ON eep_jobs ( menuflag )
GO
 