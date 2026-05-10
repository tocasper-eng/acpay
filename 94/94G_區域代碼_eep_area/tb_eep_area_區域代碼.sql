use cfp 
go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_area]') AND type in (N'U'))
   DROP TABLE  eep_area
GO
--區域代碼
CREATE TABLE eep_area(
num   bigint IDENTITY(1,1)   not null,--主流水號
areano       char(08)        not null,--收款條件
areanm       nvarchar(96)        null,--條件名稱
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
chjernov     nvarchar(99)        null,--作廢資訊
chjernop     nvarchar(99)        null,--過帳資訊
chjernod     nvarchar(99)        null,--複製資訊
chjernom     nvarchar(99)        null,--製單資訊
chjernos     nvarchar(99)        null,--審核資訊
chjernoz     nvarchar(99)        null,--核准資訊
chjernoa     nvarchar(99)        null,--採立資訊
chjernoe     nvarchar(99)        null,--立帳資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_area_areano primary key ( areano )  
)
GO 
CREATE unique INDEX in_eep_area_num      ON eep_area  ( num  )
CREATE 　　　 INDEX in_eep_area_menuflag ON eep_area  ( menuflag )
CREATE 　　　 INDEX in_eep_area_chjernod ON eep_area  ( chjernoi )
CREATE 　　　 INDEX in_eep_area_chjernoz ON eep_area  ( chjernoi )
GO
 