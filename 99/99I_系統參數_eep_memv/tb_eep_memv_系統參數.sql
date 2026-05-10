--USE cf99p
--GO
--delete eep_memv 
--truncate table eep_memv 

--insert into eep_memv ( systno , yyyymm,c01) values ('99B','202604','ACPAYacpay')

--select * from eep_memv 
--select c01 from eep_memv where systno='99B' order by yyyymm desc 

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_memv]') AND type in (N'U'))
   DROP TABLE  eep_memv
GO
--系統參數
CREATE TABLE eep_memv(
num   bigint  IDENTITY(1,1)  not null,--主流水號
systno       nvarchar(96)    not null,--功能代碼
yyyymm       nvarchar(96)    not null,--生效年月
c01          nvarchar(96)        null,--文字之一
c02          nvarchar(96)        null,--文字之二
c03          nvarchar(96)        null,--文字之三
c04          nvarchar(96)        null,--文字之四
c05          nvarchar(96)        null,--文字之五
n01          decimal(20,4)       null,--數字之一
n02          decimal(20,4)       null,--數字之二
n03          decimal(20,4)       null,--數字之三
n04          decimal(20,4)       null,--數字之四
n05          decimal(20,4)       null,--數字之五
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_memv_systno_yyyymm primary key ( systno,yyyymm)  
)
GO 
CREATE unique INDEX in_eep_memv_num  ON eep_memv  ( num )
CREATE        INDEX in_eep_memv_menuflag      ON eep_memv  ( menuflag )
GO
 
