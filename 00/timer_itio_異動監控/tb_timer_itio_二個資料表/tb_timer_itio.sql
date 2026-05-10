USE cfp
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[timer_itio]') AND type in (N'U'))
   DROP TABLE timer_itio
GO
CREATE TABLE timer_itio(
menuflag   char(20) NOT NULL,
cal        bigint       NULL,
dt         datetime     NULL,
ok         char(1)      NULL,
chjerno    nvarchar(99) null,
num        bigint IDENTITY(1,1) 
constraint pk_timer_itio  primary key ( num )  
)
GO 
CREATE INDEX in_timer_itio_menuflag     ON timer_itio ( menuflag )
CREATE INDEX in_timer_itio_dt           ON timer_itio ( dt )
GO
--use chjer
--go
--IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='timer_eep')
--   DROP VIEW timer_eep
--GO
--CREATE VIEW timer_eep as select * from casper.dbo.timer_eep 
--go

