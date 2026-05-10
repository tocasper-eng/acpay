use acpay 

go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pos_d_30]') AND type in (N'U'))
   DROP TABLE  pos_d_30
GO
 

--內部備註
CREATE TABLE pos_d_30(
num   bigint  IDENTITY(1,1)   not null,--主流水號 
契約編號      nvarchar(20)    not null,--契約編號 
dt            datetime        not null,--補充日期
seq           char(04)        not null,--項次
remark        nvarchar(100)       null,--備註說明
flowflag      char(50)            null,--流程旗標
menuflag      char(20)            null,--選單旗標 
chjernoi      nvarchar(99)        null,--建檔資訊 
chjernou      nvarchar(99)        null,--修改資訊
chjernoc      nvarchar(99)        null,--結案資訊
chjernop      nvarchar(99)        null,--過帳資訊
chjernov      nvarchar(99)        null,--作廢資訊
chjernoz      nvarchar(99)        null,--核准資訊
constraint pk_pos_d_30_契約編號_dt_seq primary key (契約編號, dt,seq)  
)
GO 
CREATE unique INDEX in_pos_d_30_num      ON pos_d_30(  num        )
CREATE        INDEX in_pos_d_30_menuflag ON pos_d_30( menuflag    )
GO
 