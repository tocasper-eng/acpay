USE  cfp
GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_001_timer_void]'))
   DROP TRIGGER tr_001_timer_void
GO
create trigger tr_001_timer_void  on timer_void
after delete 
as
begin 

insert into timer_void_del( menuflag , cal     ,dt      ,ok      ,num     ,del_dt , chjerno   )
select menuflag,cal     ,dt      ,ok      ,num     ,getdate() , chjerno  
from deleted 


end 


GO


