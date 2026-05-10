USE cfp
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[timer_ledger]') AND type in (N'U'))
   DROP TABLE timer_ledger
GO
CREATE TABLE timer_ledger(
menuflag   char(20) NOT NULL,
cal        bigint       NULL,
dt         datetime     NULL,
ok         char(1)      NULL,
chjerno    nvarchar(99) null,
num        bigint IDENTITY(1,1)  
constraint pk_timer_ledger  primary key ( num )  
)
GO 
CREATE INDEX in_timer_ledger_menuflag     ON timer_ledger ( menuflag )
CREATE INDEX in_timer_ledger_dt           ON timer_ledger ( dt )
GO
 