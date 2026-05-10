use cfp 
go 

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_co2e]') AND type in (N'U'))
   DROP TABLE  eep_co2e
GO
--碳排當量
CREATE TABLE eep_co2e(
num   bigint  IDENTITY(1,1)  not null,--主流水號
itemno       nvarchar(20)    not null,--物料代碼
co2eno       nvarchar(96)        null,--資料來源
qtyw2        decimal(20,10)      null,--碳排當量
datefm       datetime        not null,--生效起日
dateto       datetime        not null,--生效止日
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_co2e_itemno_datefm_dateto primary key ( itemno,datefm,dateto )  
)
GO 
CREATE unique INDEX in_eep_co2e_num ON eep_co2e ( num  )
CREATE        INDEX in_eep_co2e_co2eno                ON eep_co2e ( co2eno  )
CREATE        INDEX in_eep_co2e_menuflag              ON eep_co2e ( menuflag)
GO
 