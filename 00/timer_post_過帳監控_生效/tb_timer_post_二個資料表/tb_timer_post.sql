USE cfp
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[timer_post]') AND type in (N'U'))
   DROP TABLE timer_post
GO
CREATE TABLE timer_post(
menuflag   char(20) NOT NULL,
cal        bigint       NULL,
dt         datetime     NULL,
ok         char(1)      NULL,
chjerno    nvarchar(99) null,
num        bigint IDENTITY(1,1)  
constraint pk_timer_post  primary key ( num )  
)
GO 
CREATE INDEX in_timer_post_menuflag     ON timer_post ( menuflag )
CREATE INDEX in_timer_post_dt           ON timer_post ( dt )
GO
--use chjer
--go
--IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='timer_eep')
--   DROP VIEW timer_eep
--GO
--CREATE VIEW timer_eep as select * from casper.dbo.timer_eep 
--go

