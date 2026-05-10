--use cfp 
--go
if exists (select name from sysobjects where name = 'ep_910_00')
   drop procedure ep_910_00
go
--exec chjer.dbo.eep_910_00 980 
create procedure ep_910_00
(
@menuflag char(20) 
)
--casper--
as
begin

update eep_sono2 set remark = '1,'+isnull(remark,'')  where menuflag = @menuflag  

end 
GO

