--use cfp 
--go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_item]') AND type in (N'U'))
   DROP TABLE  eep_item
GO
--物料主檔
--alter table eep_item add kg           decimal(20,4)       null--單位重量
--alter table eep_item drop column  swt
--alter table eep_item add swt          nvarchar(20)        null--盤點標的
CREATE TABLE eep_item(
num   bigint  IDENTITY(1,1)  not null,--主流水號
itemno       char(20)        not null,--物料編號
itemnm       nvarchar(96)        null,--物料名稱
specnm       nvarchar(96)        null,--物料規格
unitno       char(08)            null,--標示單位
clasno       char(08)            null,--物料大類
clasnm       nvarchar(96)        null,--大類名稱
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--佐証文件
constraint pk_eep_item_itemno primary key ( itemno )  
)
GO 
CREATE unique INDEX in_item_num      ON eep_item  ( num      )
CREATE        INDEX in_item_clasno   ON eep_item  ( clasno   )
CREATE        INDEX in_item_menuflag ON eep_item  ( menuflag )
GO
 