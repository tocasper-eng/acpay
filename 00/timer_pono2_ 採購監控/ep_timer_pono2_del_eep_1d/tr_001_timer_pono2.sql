USE  cfp
GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_001_timer_pono2]'))
   DROP TRIGGER tr_001_timer_pono2
GO
create trigger tr_001_timer_pono2  on timer_pono2
after delete 
as
begin 

insert into timer_sono2_del( menuflag , cal     ,dt      ,ok      ,num     ,del_dt , chjerno  )
select menuflag,cal     ,dt      ,ok      ,num     ,getdate() , chjerno 
from deleted 


end 


GO


