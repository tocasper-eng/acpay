--use cfp 
--go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_group2]') AND type in (N'U'))
   DROP TABLE  eep_group2
GO
--利潤中心
CREATE TABLE eep_group2(
num   bigint  IDENTITY(1,1)  not null,--主流水號
group1       char(01)            null,--集團代碼
name1        nvarchar(96)        null,--集團名稱
group2       char(02)        not null,--利潤中心
name2        nvarchar(96)        null,--中心名稱
depanm       nvarchar(96)        null,--部門名稱
depano       char(06)            null,--部門編號
currno       char(03)            null,--本幣幣別
cldate       datetime            null,--關帳日期
--bs         char(01)            null,--BS層級
--ps         char(08)            null,--專案BS
--gw         char(08)            null,--批號管理
--ga         char(08)            null,--序號管理
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_group2_group2 primary key ( group2 )  
)
GO 
CREATE unique INDEX in_eep_group2_num  ON eep_group2  ( num )
CREATE        INDEX in_eep_group2_menuflag ON eep_group2  ( menuflag )
CREATE        INDEX in_eep_group2_depano   ON eep_group2  ( depano   )
 
GO
 