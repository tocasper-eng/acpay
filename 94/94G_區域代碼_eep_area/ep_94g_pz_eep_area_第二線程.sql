use cfp 
go
if exists (select name from sysobjects where name = 'ep_94g_pz')
   drop procedure ep_94g_pz
go
--select * from eep_area '94G_00_0000000000008','d'

--exec chjer.dbo.ep_94g_pz '94G_00_0000000000008','d'
create procedure ep_94g_pz
(
@menuflag char(20) ,
@chjernop nvarchar(99) 
)
--casper--
as
begin
 
   --這裡寫更新程序
 declare @cnt int 

 
 
end 
GO

