USE  cfp
GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_001_timer_codez]'))
   DROP TRIGGER tr_001_timer_codez
GO
create trigger tr_001_timer_codez  on timer_codez
after delete 
as
begin 

insert into timer_codez_del( menuflag , cal     ,dt      ,ok      ,num     ,del_dt , chjerno  )
select menuflag,cal     ,dt      ,ok      ,num     ,getdate() , chjerno  
from deleted 


end 


GO


