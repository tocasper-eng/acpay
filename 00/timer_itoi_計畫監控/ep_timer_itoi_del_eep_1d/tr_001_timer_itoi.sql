--USE [casper]
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * fROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_001_timer_itoi]'))
   DROP TRIGGER tr_001_timer_itoi
GO
create trigger tr_001_timer_itoi on timer_itoi
after delete 
as
begin 

insert into timer_itoi_del( menuflag , cal     ,dt      ,ok      ,num     ,del_dt , chjerno   )
select menuflag,cal     ,dt      ,ok      ,num     ,getdate() , chjerno 
from deleted 


end 


GO


