use cfp 
go
if exists (select name from sysobjects where name = 'ep_94g_pt')
   drop procedure ep_94g_pt
go
--select * from eep_area '94G_00_0000000000008','d'

--exec chjer.dbo.ep_94g_pt '94G_00_0000000000008','d'
create procedure ep_94g_pt
(
@menuflag char(20) ,
@chjernop nvarchar(99) 
)
--casper--
as
begin
 
   --這裡寫更新程序
 

   update eep_area set chjernop = @chjernop where menuflag = @menuflag  

   --繼續後續的處理
   insert into timer_codep( menuflag ,chjerno  ,ok ) values ( @menuflag , @chjernop  , 'N') 
   
end 
GO

