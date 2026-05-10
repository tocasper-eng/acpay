USE cfp
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_c223]') AND type in (N'U'))
   DROP TABLE  eep_c223
GO
--生產版本
CREATE TABLE eep_c223(
num   bigint  IDENTITY(1,1)  not null,--主流水號
itemno       nvarchar(20)    not null,--物料代碼
rtno         nvarchar(20)    not null,--途程代碼
bmno         nvarchar(20)    not null,--用量代碼
datefm       datetime            null,--生效起日
dateto       datetime            null,--生效止日
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_c223_itemno_rtno_bmno primary key ( itemno,rtno,bmno )  
)
GO 
CREATE unique INDEX in_eep_c223_num  ON eep_c223 ( num  )
CREATE        INDEX in_eep_c223_rtno              ON eep_c223 ( rtno     )
CREATE        INDEX in_eep_c223_bmno              ON eep_c223 ( bmno     )
CREATE        INDEX in_eep_c223_menuflag          ON eep_c223 ( menuflag )
GO
 