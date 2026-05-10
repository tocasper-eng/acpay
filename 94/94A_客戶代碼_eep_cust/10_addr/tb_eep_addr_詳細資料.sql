use acpay 

go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_adde]') AND type in (N'U'))
   DROP TABLE  eep_adde
GO
--詳細資料
CREATE TABLE eep_adde(
num   bigint IDENTITY(1,1)   not null,--主流水號--第一鍵值
emplno       char(08)        not null,--客戶編號 
seq          char(04)        not null,--項次
addeno       nvarchar(20)        null,--內容代碼
addenm       nvarchar(20)        null,--內容說明
remark       nvarchar(100)       null,--內容描述
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null --修改資訊
 
constraint pk_eep_adde_emplno_seq primary key ( emplno , seq )  
)
GO 
CREATE unique INDEX in_eep_adde_num      ON eep_adde( num         )
CREATE        INDEX in_eep_adde_menuflag ON eep_adde( menuflag    )
CREATE        INDEX in_eep_adde_addeno   ON eep_adde( addeno      )
GO
 