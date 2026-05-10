--use cfp 
--go

if exists (select name from sysobjects where name = 'ep_92r_00')
   drop procedure ep_92r_00
go
--exec chjer.dbo.ep_92r_00 980 
create procedure ep_92r_00
(
@menuflag char(20) 
)
--casper--
as
begin

  update eep_id04 set remark = '1,'+isnull(remark,'')  where menuflag = @menuflag  

end 
GO

