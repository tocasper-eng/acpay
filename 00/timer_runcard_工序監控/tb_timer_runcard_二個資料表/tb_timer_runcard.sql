USE cfp
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[timer_runcard]') AND type in (N'U'))
   DROP TABLE timer_runcard
GO
CREATE TABLE timer_runcard(
menuflag   char(20) NOT NULL,
cal        bigint       NULL,
dt         datetime     NULL,
ok         char(1)      NULL,
chjerno    nvarchar(99) null,
num        bigint IDENTITY(1,1)  
constraint pk_timer_runcard  primary key ( num )  
)
GO 
CREATE INDEX in_timer_runcard_menuflag     ON timer_runcard ( menuflag )
CREATE INDEX in_timer_runcard_dt           ON timer_runcard ( dt )
GO
 