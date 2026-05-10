--use cfp 
--go

if exists (select name from sysobjects where name = 'ep_94r_01')
   drop procedure ep_94r_01
go
--exec chjer.dbo.ep_94r_01 980 
create procedure ep_94r_01
(
@menuflag char(20) 
)
--casper--
as
begin

  update eep_addr set remark = '1,'+isnull(remark,'')  where menuflag = @menuflag  

end 
GO

