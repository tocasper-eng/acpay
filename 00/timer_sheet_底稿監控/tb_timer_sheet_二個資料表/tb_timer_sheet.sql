USE cfp
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[timer_sheet]') AND type in (N'U'))
   DROP TABLE timer_sheet
GO
CREATE TABLE timer_sheet(
menuflag   char(20) NOT NULL,
cal        bigint       NULL,
dt         datetime     NULL,
ok         char(1)      NULL,
chjerno    nvarchar(99) null,
num        bigint IDENTITY(1,1)  
constraint pk_timer_sheet  primary key ( num )  
)
GO 
CREATE INDEX in_timer_sheet_menuflag     ON timer_sheet ( menuflag )
CREATE INDEX in_timer_sheet_dt           ON timer_sheet ( dt )
GO
 