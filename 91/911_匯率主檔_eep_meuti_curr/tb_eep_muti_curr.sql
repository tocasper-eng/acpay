--USE cfp
--GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_muti_curr]') AND type in (N'U'))
   DROP TABLE [dbo].[eep_muti_curr]
GO
CREATE TABLE [dbo].[eep_muti_curr](
[num]      [bigint] IDENTITY(1,1) NOT NULL,
[currnofm] [char](3)       not   NULL,--來原幣別
[currnoto] [char](3)       not   NULL,--目的幣別
[exrate]   [decimal](10, 4)      NULL,--標準匯率
[exrate2]  [decimal](10, 4)      NULL,--買進匯率
[exrate3]  [decimal](10, 4)      NULL,--賣出匯率
[dec_pri]  [int]                 NULL,--小數位數
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_addr_currnofm_currnoto primary key ( currnofm,currnoto )  
)
GO 
CREATE unique INDEX in_eep_muti_curr_num  ON eep_muti_curr ( num  )
CREATE        INDEX in_eep_muti_curr_menulfag           ON eep_muti_curr ( menuflag )

GO