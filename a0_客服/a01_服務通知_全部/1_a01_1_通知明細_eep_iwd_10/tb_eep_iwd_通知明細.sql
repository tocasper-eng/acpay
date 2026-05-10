use acpay 

go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_iwd_10]') AND type in (N'U'))
   DROP TABLE  eep_iwd_10
GO
--語音內容
CREATE TABLE eep_iwd_10(
num   bigint  IDENTITY(1,1)   not null,--主流水號--第一鍵值
iwno          char(20)        not null,--通知編號--上對下
iwseq         char(04)        not null,--項次
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
constraint pk_eep_iwd_iwno_iwseq2 primary key ( iwno,iwseq )  
)
GO 
CREATE unique INDEX in_eep_iwd_10_num      ON eep_iwd_10(  num        )
CREATE        INDEX in_eep_iwd_10_iwno     ON eep_iwd_10( iwno        )
CREATE        INDEX in_eep_iwd_10_menuflag ON eep_iwd_10( menuflag    )
GO
 