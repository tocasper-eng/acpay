use cfp 
go

if exists (select name from sysobjects where name = 'ep_94g_vy')
   drop procedure ep_94g_vy
go
--exec chjer.dbo.ep_94g_vy 980 
create procedure ep_94g_vy
(
@menuflag char(20)     ,
@chjernov nvarchar(99) 
)
--casper--
as
begin

 
   --select @chjernov = chjernov  
 
   --from eep_area 
   --where menuflag = @menuflag
   
   --已作廢不處理
   if substring(isnull(@chjernov,''),1,1)='Y' return 
   --已核准不處理
   if substring(isnull(@chjernov,''),1,1)='Y' return 

   
   if substring(@chjernov,1,1) in ('Y','N')
      set @chjernov = 'Y' + substring(@chjernov,2,99)
   else 
      set @chjernov = 'Y' + '::' + @chjernov 


   --這裡寫核准程序
   --這裡寫核准程序
   --這裡寫核准程序
   --這裡寫核准程序
   update eep_area set remark = '1' where menuflag = @menuflag  
   update eep_area set chjernov = @chjernov where menuflag = @menuflag  

   --繼續後續的處理
   insert into timer_void( menuflag ,chjerno ,ok ) values ( @menuflag , @chjernov , 'N') 
   
end 
GO

