USE cfp
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[timer_budg]') AND type in (N'U'))
   DROP TABLE timer_budg
GO
CREATE TABLE timer_budg(
menuflag   char(20) NOT NULL,
cal        bigint       NULL,
dt         datetime     NULL,
ok         char(1)      NULL,
chjerno    nvarchar(99) null,
num        bigint IDENTITY(1,1)  
constraint pk_timer_budg  primary key ( num )  
)
GO 
CREATE INDEX in_timer_budg_menuflag     ON timer_budg ( menuflag )
CREATE INDEX in_timer_budg_dt           ON timer_budg ( dt )
GO
--use chjer
--go
--IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='timer_eep')
--   DROP VIEW timer_eep
--GO
--CREATE VIEW timer_eep as select * from casper.dbo.timer_eep 
--go

