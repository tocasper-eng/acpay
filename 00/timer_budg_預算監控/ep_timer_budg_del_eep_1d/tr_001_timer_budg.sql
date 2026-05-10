USE  cfp
GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_001_timer_budg]'))
   DROP TRIGGER tr_001_timer_budg
GO
create trigger tr_001_timer_budg  on timer_budg
after delete 
as
begin 

insert into timer_budg_del( menuflag , cal     ,dt      ,ok      ,num     ,del_dt , chjerno  )
select menuflag,cal     ,dt      ,ok      ,num     ,getdate() , chjerno 
from deleted 


end 


GO


