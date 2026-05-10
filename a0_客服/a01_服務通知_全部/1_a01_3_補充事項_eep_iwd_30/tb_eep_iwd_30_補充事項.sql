use acpay 

go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_iwd_30]') AND type in (N'U'))
   DROP TABLE  eep_iwd_30
GO
--alter table eep_iwd_20 add signatures    nvarchar(max)       null --客戶簽名
--alter table eep_iwd_20 add signatures    nvarchar(max)       null --客戶簽名
--alter table eep_iwd_20 add files1        nvarchar(100)       null--照片一
--alter table eep_iwd_20 add files2        nvarchar(100)       null--照片二
--alter table eep_iwd_20 add files3        nvarchar(100)       null--照片三

--補充事項
CREATE TABLE eep_iwd_30(
num   bigint  IDENTITY(1,1)   not null,--主流水號--第一鍵值
iwno          char(20)        not null,--通知編號--上對下
iwseq         char(04)        not null,--項次
dt            datetime            null,--補充日期
remark        nvarchar(100)       null,--備註說明
flowflag      char(50)            null,--流程旗標
menuflag      char(20)            null,--選單旗標 
chjernoi      nvarchar(99)        null,--建檔資訊 
chjernou      nvarchar(99)        null,--修改資訊
chjernoc      nvarchar(99)        null,--結案資訊
chjernop      nvarchar(99)        null,--過帳資訊
chjernov      nvarchar(99)        null,--作廢資訊
chjernoz      nvarchar(99)        null,--核准資訊
constraint pk_eep_iwd_30_iwno_iwseq primary key ( iwno,iwseq )  
)
GO 
CREATE unique INDEX in_eep_iwd_30_num      ON eep_iwd_30(  num        )
CREATE        INDEX in_eep_iwd_30_iwno     ON eep_iwd_30( iwno        )
CREATE        INDEX in_eep_iwd_30_menuflag ON eep_iwd_30( menuflag    )
GO
 