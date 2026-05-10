
use acpay 

go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_lined]') AND type in (N'U'))
   DROP TABLE  eep_lined
GO
--語音內容
CREATE TABLE eep_lined(
num   bigint  IDENTITY(1,1)       not null,--主流水號
linenum       nvarchar(20)        not null,--班組編號
emplno        nvarchar(08)        not null,--員工編號
emplnm        nvarchar(96)        not null,--通知編號
remark        nvarchar(96)        null,--備註說明
files         nvarchar(100)       null,--檔案路徑
flowflag      char(50)            null,--流程旗標
menuflag      char(20)            null,--選單旗標--第一鍵值
chjernoi      nvarchar(99)        null,--建檔資訊 
chjernou      nvarchar(99)        null,--修改資訊
chjernoc      nvarchar(99)        null,--結案資訊
chjernop      nvarchar(99)        null,--過帳資訊
chjernov      nvarchar(99)        null,--作廢資訊
chjernoz      nvarchar(99)        null,--核准資訊
constraint pk_eep_lined_linenum_emplno primary key ( linenum , emplno  )  
)
GO 
CREATE unique INDEX in_eep_lined_num      ON eep_lined(  num        )
CREATE        INDEX in_eep_lined_menuflag ON eep_lined( menuflag    )
GO
 