--use cfp 
--go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_cpno]') AND type in (N'U'))
   DROP TABLE  eep_cpno
GO
--價格條件
CREATE TABLE eep_cpno(
num   bigint  IDENTITY(1,1)  not null,--主流水號
itemno       char(20)        not null,--產品名稱
itemnm       nvarchar(96)        null,--客戶名稱
custno       char(08)        not null,--客戶代碼
custnm       nvarchar(96)        null,--客戶名稱
cpnono       char(20)        not null,--客戶物料
cpnonm       nvarchar(96)        null,--物料名稱
price        decimal(20,2)       null,--單價
currno       char(03)            null,--幣別
datefm       datetime       not  null,--起始日期
dateto       datetime       not  null,--終止日期  
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_cpno_itemno_custno_cpnono_datefm_dateto primary key ( itemno,custno,cpnono,datefm,dateto  )  
)
GO 
CREATE unique INDEX in_eep_cpno_num   ON eep_cpno ( num  )
CREATE        INDEX in_eep_cpno_menuflag ON eep_cpno ( menuflag  )
GO

