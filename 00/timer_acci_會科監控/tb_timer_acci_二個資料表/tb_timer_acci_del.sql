--USE cfp
--GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[timer_acci_del]') AND type in (N'U'))
   DROP TABLE timer_acci_del
GO
CREATE TABLE timer_acci_del(
menuflag       char(20)     NOT NULL,
cal            bigint           NULL,
dt             datetime         NULL,
ok             char(1)          NULL,
chjerno        nvarchar(99) null,
num            bigint       not null,
del_dt         datetime     NOT NULL,
constraint pk_timer_acci_del_num_dt primary key ( num , del_dt )  
)
GO 
CREATE INDEX in_timer_acci_del_menuflag     oN timer_acci_del ( menuflag )
CREATE INDEX in_timer_acci_del_del_dt       ON timer_acci_del ( del_dt   )
GO
 