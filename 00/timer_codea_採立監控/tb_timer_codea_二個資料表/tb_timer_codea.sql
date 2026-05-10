USE cfp
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[timer_codea]') AND type in (N'U'))
   DROP TABLE timer_codea
GO
CREATE TABLE timer_codea(
menuflag   char(20) NOT NULL,--©I¥s¨Ó·½
cal        bigint       NULL,
dt         datetime     NULL,
ok         char(1)      NULL,
chjerno    nvarchar(99) null,--®Ö­ã¸ê°T
num        bigint IDENTITY(1,1)  
constraint pk_timer_codea  primary key ( num )  
)
GO 
CREATE INDEX in_timer_codea_menuflag     ON timer_codea ( menuflag )
CREATE INDEX in_timer_codea_dt           ON timer_codea ( dt )
GO
--use chjer
--go
--IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='timer_eep')
--   DROP VIEW timer_eep
--GO
--CREATE VIEW timer_eep as select * from casper.dbo.timer_eep 
--go

