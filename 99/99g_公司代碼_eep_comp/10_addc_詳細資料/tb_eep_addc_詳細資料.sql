use acpay 

go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_addc]') AND type in (N'U'))
   DROP TABLE  eep_addc
GO
--詳細資料
CREATE TABLE eep_addc(
num   bigint IDENTITY(1,1)   not null,--主流水號--第一鍵值
compno       char(08)        not null,--公司編號 
seq          char(04)        not null,--項次
addcno       nvarchar(20)        null,--內容代碼
addcnm       nvarchar(20)        null,--內容說明
remark       nvarchar(100)       null,--內容描述
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null --修改資訊
 
constraint pk_eep_addp_compno_seq primary key ( compno , seq )  
)
GO 
CREATE unique INDEX in_eep_addc_num      ON eep_addc( num         )
CREATE        INDEX in_eep_addc_menuflag ON eep_addc( menuflag    )
CREATE        INDEX in_eep_addc_addpno   ON eep_addc( addcno      )
GO
 