use acpay 

go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_addp]') AND type in (N'U'))
   DROP TABLE  eep_addp
GO
--詳細資料
CREATE TABLE eep_addp(
num   bigint IDENTITY(1,1)   not null,--主流水號--第一鍵值
factno       char(08)        not null,--廠商編號 
seq          char(04)        not null,--項次
addpno       nvarchar(20)        null,--內容代碼
addpnm       nvarchar(20)        null,--內容說明
remark       nvarchar(100)       null,--內容描述
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null --修改資訊
 
constraint pk_eep_addp_factno_seq primary key ( factno , seq )  
)
GO 
CREATE unique INDEX in_eep_addp_num      ON eep_addp( num         )
CREATE        INDEX in_eep_addp_menuflag ON eep_addp( menuflag    )
CREATE        INDEX in_eep_addp_addpno   ON eep_addp( addpno      )
GO
 