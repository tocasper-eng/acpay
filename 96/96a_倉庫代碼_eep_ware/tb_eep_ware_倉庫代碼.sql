--use cfp
--go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_ware]') AND type in (N'U'))
   DROP TABLE  eep_ware
GO
--倉庫代碼
CREATE TABLE eep_ware(
num   bigint  IDENTITY(1,1)  not null,--主流水號
wareno       char(08)        not null,--倉庫代碼
warenm       nvarchar(96)        null,--倉庫名稱
plantno      char(08)            null,--工廠代碼
plantnm      nvarchar(96)        null,--工廠名稱
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_ware_wareno primary key ( wareno )  
)
GO 
CREATE unique INDEX in_eep_ware_num      ON eep_ware  ( num   )
CREATE        INDEX in_eep_ware_menuflag ON eep_ware  ( menuflag )
CREATE        INDEX in_eep_ware_plantno  ON eep_ware  ( plantno  )
GO
 