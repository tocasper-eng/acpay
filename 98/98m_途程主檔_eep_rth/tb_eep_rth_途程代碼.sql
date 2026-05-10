use cfp
go 

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_rth]') AND type in (N'U'))
   DROP TABLE  eep_rth
GO
--途程主檔
CREATE TABLE eep_rth(
num   bigint  IDENTITY(1,1)  not null,--主流水號
rtno         char(20)        not null,--途程代碼
rtnm         nvarchar(96)        null,--途程名稱
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_rtno_rtno primary key (rtno )  
)
GO 
CREATE unique INDEX in_eep_rth_num       ON eep_rth( num       )
CREATE        INDEX in_eep_rth_menuflag   ON eep_rth( menuflag    )
GO
 