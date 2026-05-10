--use cfp 
--go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_remanm]') AND type in (N'U'))
   DROP TABLE  eep_remanm
GO
--分析碼一

CREATE TABLE eep_remanm(
num   bigint IDENTITY(1,1)   not null,--主流水號
remanm       nvarchar(20)    not null,--分析碼四
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_remanm_remanm primary key ( remanm )  
)
GO 
CREATE unique INDEX in_eep_remanm_num    ON eep_remanm( num    )
CREATE        INDEX in_eep_remanm_menuflag ON eep_remanm( menuflag )
GO
 