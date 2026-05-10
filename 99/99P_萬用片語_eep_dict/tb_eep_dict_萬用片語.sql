--USE cfp
--GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_dict]') AND type in (N'U'))
   DROP TABLE  eep_dict
GO
--萬用片語
CREATE TABLE eep_dict(
num   bigint  IDENTITY(1,1)  not null,--主流水號
dictno       nvarchar(96)    not null,--片語代碼
dictnm       nvarchar(96)    not null,--片語內容
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_dict_dictno_dictnm primary key ( dictno,dictnm )  
)
GO 
CREATE unique INDEX in_eep_dict_num    ON eep_dict  ( num   )
CREATE        INDEX in_eep_dict_menuflag ON eep_dict  ( menuflag       )
GO
 