USE cfp
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[timer_eep]') AND type in (N'U'))
   DROP TABLE timer_eep
GO
CREATE TABLE timer_eep(
menuflag   char(20) NOT NULL,
cal        bigint       NULL,
dt         datetime     NULL,
ok         char(1)      NULL,
chjernoi   nvarchar(99) null,
chjerno    nvarchar(99) null,
num        bigint IDENTITY(1,1)  
constraint pk_timer_eep  primary key ( num )  
)
GO 
CREATE INDEX in_timer_menuflag     ON timer_eep ( menuflag )
CREATE INDEX in_timer_dt           ON timer_eep ( dt )
GO
--use chjer
--go
--IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='timer_eep')
--   DROP VIEW timer_eep
--GO
--CREATE VIEW timer_eep as select * from casper.dbo.timer_eep 
--go

