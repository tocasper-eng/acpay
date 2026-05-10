--USE cfp
--GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_di]') AND type in (N'U'))
   DROP TABLE  eep_di
GO
--關聯號碼
CREATE TABLE eep_di(
num   bigint  IDENTITY(1,1)  not null,--主流水號
di           char(02)        not null,--關聯號碼
dinm         nvarchar(96)        null,--關聯名稱
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_di_di primary key ( di )  
)
GO 
CREATE unique INDEX in_eep_di_num       ON eep_di( num       )
CREATE        INDEX in_eep_di_menuflag ON eep_di( menuflag )
GO
 