use acpay
go

if exists (select name from sysobjects where name = 'ep_a01_vy')
   drop procedure ep_a01_vy
go
--select * from eep_iwh 
--exec .dbo.ep_a01_vy 'A01_00_0000000000002','y' 
create procedure ep_a01_vy
(
@menuflag char(20)     ,
@chjerno nvarchar(99) 
)
--casper--
as
begin

 
declare @chjernov nvarchar(100) 

   select @chjernov = chjernov  
 
   from eep_iwh 
   where menuflag = @menuflag
   
   --已作廢不處理
   if substring(isnull(@chjernov,''),1,1)='Y' return 
 
 
   
 
set @chjernov = 'Y::' + isnull(@chjerno,'') 
 

   --這裡寫核准程序
   --這裡寫核准程序
   --這裡寫核准程序
   --這裡寫核准程序
   update eep_iwh set chjernov = @chjernov where menuflag = @menuflag  

insert into eep_logs(dt,menuflag,chjernov) 
values ( GETDATE() , @menuflag,@chjernov ) 
end 
GO

