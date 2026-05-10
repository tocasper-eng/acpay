--USE cfp
--GO
/****** Object:  Table [dbo].[soh_rpt2]    Script Date: 07/12/2012 09:52:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_muti_exra]') AND type in (N'U'))
   DROP TABLE [dbo].[eep_muti_exra]
GO
CREATE TABLE [dbo].[eep_muti_exra](
num       bigint IDENTITY(1,1) NOT NULL,--子流水號
currnofm  char(03)               not  NULL,--來原幣別
currnoto  char(03)               not  NULL,--目的幣別
datefm    datetime               not  NULL,--起始日期
dateto    datetime               not  NULL,--終止日期
exrate    decimal(10, 4)              NULL,--標準匯率
exrate2   decimal(10, 4)              NULL,--買進匯率
exrate3   decimal(10, 4)              NULL,--賣出匯率
flowflag  char(50)                    null,--流程旗標
menuflag  char(20)                    null,--選單旗標
chjernoi  nvarchar(99)                null,--建檔資訊
chjernou  nvarchar(99)                null,--修改資訊
remark    nvarchar(96)                null,--備註說明
constraint pk_eep_muti_exra_currnofm_currnoto_datefm_dateto primary key ( currnofm,currnoto,datefm,dateto  )  
)
GO 
CREATE        INDEX in_eep_muti_exra_menulfag  ON eep_muti_exra ( menuflag )
CREATE unique INDEX in_eep_muti_exra_num       ON eep_muti_exra ( num      )

GO
 