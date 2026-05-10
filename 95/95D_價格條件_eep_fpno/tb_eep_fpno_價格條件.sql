--use cfp 
--go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_fpno]') AND type in (N'U'))
   DROP TABLE  eep_fpno
GO
--價格條件
CREATE TABLE eep_fpno(
num   bigint  IDENTITY(1,1)  not null,--主流水號
itemno       char(20)        not null,--產品名稱
itemnm       nvarchar(96)        null,--客戶名稱
factno       char(08)        not null,--客戶代碼
factnm       nvarchar(96)        null,--客戶名稱
fpnono       char(20)        not null,--客戶物料
fpnonm       nvarchar(96)        null,--物料名稱
price        decimal(20,2)       null,--單價
currno       char(03)            null,--幣別
datefm       datetime        not null,--起始日期
dateto       datetime        not null,--終止日期  
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_fpno_itemno_factno_fpnono_datefm_dateto primary key ( itemno,factno,fpnono,datefm,dateto )  
)
GO 
CREATE unique INDEX in_eep_fpno_num   ON eep_fpno ( num )
CREATE        INDEX in_eep_fpno_menuflag ON eep_fpno ( menuflag  )
GO

