--use cfp 
--go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_sdgrp]') AND type in (N'U'))
   DROP TABLE  eep_sdgrp
GO
--銷售組織
CREATE TABLE eep_sdgrp(
num   bigint  IDENTITY(1,1)   not null,--主流水號
sdorgno       char(08)        not null,--銷售組織
sdorgnm       nvarchar(20)    not null,--銷售名稱
sdgrpno       char(08)        not null,--銷售群組
sdgrpnm       nvarchar(20)    not null,--群組名稱
emplno        char(08)            null,--員工編號
emplnm        nvarchar(20)        null,--員工名稱
clasno        char(04)            null,--產品大類
clasnm        nvarchar(20)        null,--大類名稱
kindno        char(08)            null,--客戶大類
kindnm        nvarchar(20)        null,--大類名稱
swt           char(01)            null,--預設旗標
flowflag      char(50)            null,--流程旗標
menuflag      char(20)            null,--選單旗標
chjernoi      nvarchar(99)        null,--建檔資訊
chjernou      nvarchar(99)        null,--修改資訊
remark        nvarchar(96)        null,--備註說明
constraint pk_eep_sdgrp_sdgrpno  primary key ( sdgrpno)  
)
GO 
CREATE unique INDEX in_eep_sdgrp_num      ON eep_sdgrp   ( num      )
CREATE 　　　 INDEX in_eep_sdgrp_menuflag ON eep_sdgrp   ( menuflag )
CREATE 　　　 INDEX in_eep_sdgrp_sdorgno  ON eep_sdgrp   ( sdorgno  )
CREATE 　　　 INDEX in_eep_sdgrp_clasno   ON eep_sdgrp   ( clasno   )
CREATE 　　　 INDEX in_eep_sdgrp_kindno   ON eep_sdgrp   ( kindno   )
GO
 