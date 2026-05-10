USE cfp
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[timer_codes]') AND type in (N'U'))
   DROP TABLE timer_codes
GO
CREATE TABLE timer_codes(
menuflag   char(20) NOT NULL,--©I¥s¨Ó·½
cal        bigint       NULL,
dt         datetime     NULL,
ok         char(1)      NULL,
chjerno    nvarchar(99) null,--®Ö­ã¸ê°T
num        bigint IDENTITY(1,1)  
constraint pk_timer_codes  primary key ( num )  
)
GO 
CREATE INDEX in_timer_codes_menuflag     ON timer_codes ( menuflag )
CREATE INDEX in_timer_codes_dt           ON timer_codes ( dt )
GO
--use chjer
--go
--IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='timer_eep')
--   DROP VIEW timer_eep
--GO
--CREATE VIEW timer_eep as select * from casper.dbo.timer_eep 
--go

