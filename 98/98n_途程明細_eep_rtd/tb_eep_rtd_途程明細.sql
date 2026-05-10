USE cfp
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eep_rtd]') AND type in (N'U'))
   DROP TABLE  eep_rtd
GO
--途程明細
CREATE TABLE eep_rtd(
num    bigint  IDENTITY(1,1) not null,--子流水號
rtno         char(20)        not null,--途程代碼
rtseq        char(04)        not null,--項次
ienono       char(08)            null,--製程代碼
ienonm       nvarchar(96)        null,--製程名稱
wcno         char(08)            null,--產線代碼
wcnm         nvarchar(96)        null,--產線名稱
hrs_l        decimal(10,2)       null,--人時
hrs_e        decimal(10,2)       null,--機時
flowflag     char(50)            null,--流程旗標
menuflag     char(20)            null,--選單旗標
chjernoi     nvarchar(99)        null,--建檔資訊
chjernou     nvarchar(99)        null,--修改資訊
remark       nvarchar(96)        null,--備註說明
constraint pk_eep_rtd_rtno_rtseq primary key ( rtno,rtseq )  
)
GO 
CREATE unique INDEX in_eep_rtd_num ON eep_rtd( num  )
CREATE        INDEX in_eep_rtd_ienono     ON eep_rtd( ienono      )
CREATE        INDEX in_eep_rtd_menuflag   ON eep_rtd( menuflag    )
GO
 