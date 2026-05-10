--use cfp
--go
--alter table eep_depa add compno       nvarchar(20)        null,--公司代碼
--alter table eep_depa add compnm       nvarchar(100)       null,--公司名稱

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_depa]') AND type in (N'U'))
   DROP TABLE  eep_depa
GO
--部門代碼
CREATE TABLE eep_depa(
num   bigint  IDENTITY(1,1)  not null,--主流水號
group1       char(01)            null,--集團代碼
name1        nvarchar(96)        null,--集團名稱
group2       char(02)            null,--利潤中心
name2        nvarchar(96)        null,--中心名稱
group3       char(03)            null,--廠處代碼
name3        nvarchar(96)        null,--廠處名稱
group4       char(04)            null,--四階代碼
name4        nvarchar(96)        null,--四階名稱
group5       char(05)            null,--五階代碼
name5        nvarchar(96)        null,--五階名稱
depano       char(06)        not null,--部門代碼
depanm       nvarchar(96)        null,--部門名稱
compno       nvarchar(20)        null,--公司代碼
compnm       nvarchar(100        null,--公司名稱
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_depa_depano primary key ( depano )  
)
GO 
CREATE unique INDEX in_eep_num      ON eep_depa  ( num      )
CREATE        INDEX in_eep_menuflag ON eep_depa  ( menuflag )
GO
 