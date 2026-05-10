use cfp 
go
--select * from eep_area 

--exec ep_94G_zn '94G_00_0000000000004','2025-10-14 17:14:39.890::TOCFP::TOCFP::cfp::cfp::::ffff:223.143.192.80'

if exists (select name from sysobjects where name = 'ep_94g_zn')
   drop procedure ep_94g_zn
go
--exec chjer.dbo.ep_94g_zn 980 
create procedure ep_94g_zn
(
@menuflag char(20) ,
@chjernoz nvarchar(99) 
)
--casper--
as
begin
   ----未核准不處理
   --if substring(isnull(@chjernoz,''),1,1)<>'Y' return 

   if substring(@chjernoz,1,1) in ('Y','N')
      set @chjernoz = 'N' + substring(@chjernoz,2,99)
   else 
      set @chjernoz = 'N' + '::' + @chjernoz 
   --這裡寫核准程序
   --這裡寫核准程序
   --這裡寫核准程序
   update eep_area set chjernoz = @chjernoz where menuflag = @menuflag  
   --繼續後續的處理
   insert into timer_codez( menuflag ,chjerno  ,ok ) values ( @menuflag , @chjernoz , 'N') 
end 
GO

