USE  cfp
GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_001_timer_nban]'))
   DROP TRIGGER tr_001_timer_nban
GO
create trigger tr_001_timer_nban  on timer_nban
after delete 
as
begin 

insert into timer_nban_del( menuflag , cal     ,dt      ,ok      ,num     ,del_dt , chjerno  )
select menuflag,cal     ,dt      ,ok      ,num     ,getdate() , chjerno  
from deleted 


end 


GO


