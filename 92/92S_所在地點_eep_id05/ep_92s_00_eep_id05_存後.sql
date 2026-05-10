--use cfp 
--go

if exists (select name from sysobjects where name = 'ep_92s_00')
   drop procedure ep_92s_00
go
--exec chjer.dbo.eep_92s 980 
create procedure ep_92s_00
(
@menuflag char(20) 
)
--casper--
as
begin

  update eep_id05 set remark = '1,'+isnull(remark,'')  where menuflag = @menuflag  

end 
GO

