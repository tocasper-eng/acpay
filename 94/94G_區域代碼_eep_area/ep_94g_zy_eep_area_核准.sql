use cfp 
go
if exists (select name from sysobjects where name = 'ep_94g_zy')
   drop procedure ep_94g_zy
go
--select * from eep_area '94G_00_0000000000008','d'

--exec chjer.dbo.ep_94g_zy '94G_00_0000000000008','d'
create procedure ep_94g_zy
(
@menuflag char(20) ,
@chjernoz nvarchar(99) 
)
--casper--
as
begin
   --已核准不處理
   if substring(isnull(@chjernoz,''),1,1)='Y' return 

   if substring(@chjernoz,1,1) in ('Y','N')
      set @chjernoz = 'Y' + substring(@chjernoz,2,99)
   else 
      set @chjernoz = 'Y' + '::' + @chjernoz 

   --這裡寫核准程序
   --這裡寫核准程序

   update eep_area set chjernoz = @chjernoz where menuflag = @menuflag  

   --繼續後續的處理
   insert into timer_codez( menuflag ,chjerno  ,ok ) values ( @menuflag , @chjernoz  , 'N') 
   
end 
GO

