USE  cfp
GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_001_timer_codem]'))
   DROP TRIGGER tr_001_timer_codem
GO
create trigger tr_001_timer_codem  on timer_codem
after delete 
as
begin 

insert into timer_codem_del( menuflag , cal     ,dt      ,ok      ,num     ,del_dt , chjerno  )
select menuflag,cal     ,dt      ,ok      ,num     ,getdate() , chjerno  
from deleted 


end 


GO


