--USE cfp
--GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_posi]') AND type in (N'U'))
   DROP TABLE  eep_posi
GO
--公司代碼
CREATE TABLE eep_posi(
num    bigint  IDENTITY(1,1) not null,--子流水號
posino       char(08)        not null,--儲位代碼
posinm       nvarchar(96)        null,--儲位名稱
wareno       char(08)        not null,--倉庫代碼
warenm       nvarchar(96)        null,--倉庫名稱
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_posi_wareno_posino  primary key ( wareno,posino)  
)
GO 
CREATE unique INDEX in_eep_posi_num  ON eep_posi  ( num  )
CREATE        INDEX in_eep_posi_menuflag  ON eep_posi  ( menuflag      )
GO
 