USE cfp
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[timer_cost]') AND type in (N'U'))
   DROP TABLE timer_cost
GO
CREATE TABLE timer_cost(
menuflag   char(20) NOT NULL,
cal        bigint       NULL,
dt         datetime     NULL,
ok         char(1)      NULL,
chjerno    nvarchar(99) null,
num        bigint IDENTITY(1,1) ,
constraint pk_timer_cost  primary key ( num )  
)
GO 
CREATE INDEX in_timer_cost_menuflag     ON timer_cost ( menuflag )
CREATE INDEX in_timer_cost_dt           ON timer_cost ( dt )
GO
 

