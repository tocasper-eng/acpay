USE cfp
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[timer_budg_del]') AND type in (N'U'))
   DROP TABLE timer_budg_del
GO
CREATE TABLE timer_budg_del(
menuflag       char(20)     NOT NULL,
cal            bigint           NULL,
dt             datetime         NULL,
ok             char(1)          NULL,
chjerno        nvarchar(99) null,
num            bigint       not null,
del_dt         datetime     NOT NULL,
constraint pk_timer_budg_del_num_dt primary key ( num , del_dt )  
)
GO 
CREATE INDEX in_timer_budg_del_menuflag     oN timer_budg_del ( menuflag )
CREATE INDEX in_timer_budg_del_del_dt       ON timer_budg_del ( del_dt   )
GO
--use chjer
--go
--IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='timer_eep')
--   DROP VIEW timer_eep
--GO
--CREATE VIEW timer_eep as select * from casper.dbo.timer_eep 
--go

