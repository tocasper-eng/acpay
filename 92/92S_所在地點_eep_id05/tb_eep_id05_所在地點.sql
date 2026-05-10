--use cfp 
--go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_id05]') AND type in (N'U'))
   DROP TABLE  eep_id05
GO
--所在地點
CREATE TABLE eep_id05(
num   bigint IDENTITY(1,1)   not null,--主流水號
id05no       char(08)        not null,--地點代碼
id05nm       nvarchar(96)        null,--地點名稱
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_id05_id05no primary key ( id05no )  
)
GO 
CREATE unique INDEX in_eep_id05_num   ON eep_id05( num   )
CREATE        INDEX in_eep_id05_menuflag ON eep_id05( menuflag )
GO
 