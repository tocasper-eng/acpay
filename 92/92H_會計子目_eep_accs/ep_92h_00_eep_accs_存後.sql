--use cfp 
--go

if exists (select name from sysobjects where name = 'ep_92h_00')
   drop procedure ep_92h_00
go
--exec chjer.dbo.ep_92h_00 980 
create procedure ep_92h_00
(
@menuflag char(20) 
)
--casper--
as
begin

  update eep_accs set remark = '1,'+isnull(remark,'')  where menuflag = @menuflag  

end 
GO

