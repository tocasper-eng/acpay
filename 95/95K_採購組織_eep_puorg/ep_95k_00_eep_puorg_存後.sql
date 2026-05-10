--use cfp 
--go

if exists (select name from sysobjects where name = 'ep_95k_00')
   drop procedure ep_95k_00
go
--exec chjer.dbo.ep_95k_00 980 
create procedure ep_95k_00
(
@menuflag char(20) 
)
--casper--
as
begin

declare @int int 

--  update eep_puorg set remark = '1,'+isnull(remark,'')  where menuflag = @menuflag  

end 
GO

