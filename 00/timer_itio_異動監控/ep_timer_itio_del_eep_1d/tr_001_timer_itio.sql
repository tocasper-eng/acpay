--USE [casper]
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_001_timer_itio]'))
   DROP TRIGGER tr_001_timer_itio
GO
create trigger tr_001_timer_itio  on timer_itio
after delete 
as
begin 

insert into timer_itio_del( menuflag , cal     ,dt      ,ok      ,num     ,del_dt , chjerno )
select menuflag,cal     ,dt      ,ok      ,num     ,getdate(), chjerno 
from deleted 


end 


GO


