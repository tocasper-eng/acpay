USE cfp
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[timer_pono2_del]') AND type in (N'U'))
   DROP TABLE timer_pono2_del
GO
CREATE TABLE timer_pono2_del(
menuflag       char(20)     NOT NULL,
cal            bigint           NULL,
dt             datetime         NULL,
ok             char(1)          NULL,
chjerno        nvarchar(99) null,
num            bigint       not null,
del_dt         datetime     NOT NULL,
constraint pk_timer_pono2_del_num_dt primary key ( num , del_dt )  
)
GO 
CREATE INDEX in_timer_pono2_del_menuflag     oN timer_pono2_del ( menuflag )
CREATE INDEX in_timer_pono2_del_del_dt       ON timer_pono2_del ( del_dt   )
GO
 