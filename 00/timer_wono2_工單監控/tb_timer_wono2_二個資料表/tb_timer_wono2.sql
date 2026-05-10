USE cfp
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[timer_wono2]') AND type in (N'U'))
   DROP TABLE timer_wono2
GO
CREATE TABLE timer_wono2(
menuflag   char(20) NOT NULL,
cal        bigint       NULL,
dt         datetime     NULL,
ok         char(1)      NULL,
chjerno    nvarchar(99) null,
num        bigint IDENTITY(1,1)  
constraint pk_timer_wono2  primary key ( num )  
)
GO 
CREATE INDEX in_timer_wono2_menuflag     ON timer_wono2 ( menuflag )
CREATE INDEX in_timer_wono2_dt           ON timer_wono2 ( dt )
GO
 