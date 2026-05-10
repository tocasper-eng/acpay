--use cfp 
--go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_payt]') AND type in (N'U'))
   DROP TABLE  eep_payt
GO
--客戶代碼
CREATE TABLE eep_payt(
num   bigint  IDENTITY(1,1)  not null,--主流水號
paytno       char(08)        not null,--付款條件
paytnm       nvarchar(96)        null,--條件名稱
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_payt_paytno primary key ( paytno )  
)
GO 
CREATE unique INDEX in_eep_payt_num ON eep_payt  ( num  )
CREATE 　　　 INDEX in_eep_payt_menuflag ON eep_payt  ( menuflag )
GO
 