use acpay 
go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_addr]') AND type in (N'U'))
   DROP TABLE  eep_addr
GO
--詳細資料
CREATE TABLE eep_addr(
num   bigint IDENTITY(1,1)   not null,--主流水號--第一鍵值
custno       char(08)        not null,--客戶編號 
seq          char(04)        not null,--項次
addrno       nvarchar(20)        null,--內容代碼
addrnm       nvarchar(20)        null,--內容說明
remark       nvarchar(100)       null,--內容描述
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null --修改資訊
 
constraint pk_eep_adde_custno_seq primary key ( custno  , seq )  
)
GO 
CREATE unique INDEX in_eep_addr_num      ON eep_addr( num         )
CREATE        INDEX in_eep_addr_menuflag ON eep_addr( menuflag    )
CREATE        INDEX in_eep_addr_addrno   ON eep_addr( addrno      )
GO
 