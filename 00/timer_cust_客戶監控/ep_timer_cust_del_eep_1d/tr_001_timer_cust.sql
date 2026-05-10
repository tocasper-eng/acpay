USE  cfp
GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_001_timer_cust]'))
   DROP TRIGGER tr_001_timer_cust
GO
create trigger tr_001_timer_cust  on timer_cust
after delete 
as
begin 

insert into timer_cust_del( menuflag , cal     ,dt      ,ok      ,num     ,del_dt   , chjerno )
select menuflag,cal     ,dt      ,ok      ,num     ,getdate() , chjerno 
from deleted 


end 


GO


