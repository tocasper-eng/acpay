use cfp 
go

if exists (select name from sysobjects where name = 'ep_94g_zz')
   drop procedure ep_94g_zz
go
--exec chjer.dbo.ep_94g_zz 980 
create procedure ep_94g_zz
(
@menuflag char(20) 
)
--casper--
as
begin

   declare @chjernod     nvarchar(99)  --刪除資訊
   declare @chjernoz     nvarchar(99)  --核准資訊

   select @chjernod = chjernod , 
          @chjernoz = chjernoz 
   from eep_area 
   where menuflag = @menuflag
   
 

   --會佔據前端的代碼都放在此， substring(@chjernoz,1,1) 已是正確的狀態
   --這裡寫核准程序
   --這裡寫核准程序
   --這裡寫核准程序
   --這裡寫核准程序

 
   
end 
GO

