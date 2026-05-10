--use cfp 
--go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_accs]') AND type in (N'U'))
   DROP TABLE  eep_accs
GO
--會計子目
CREATE TABLE eep_accs(
num    bigint  IDENTITY(1,1) not null,--子流水號
accino       char(06)        not null,--會計科目
accinm       nvarchar(96)        null,--科目名稱
accsno       char(08)        not null,--會計子目
accsnm       nvarchar(96)        null,--子目名稱
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_accs_accino_accsno primary key ( accino,accsno )  
)
GO 
CREATE unique INDEX in_eep_accs_num  ON eep_accs  ( num  )
CREATE        INDEX in_eep_accs_accsno        ON eep_accs  ( accsno        )
CREATE        INDEX in_eep_accs_menuflag      ON eep_accs  ( menuflag      )
GO
 