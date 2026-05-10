--use cfp 
--go
if exists (select name from sysobjects where name = 'ep_91d_00')
   drop procedure ep_91d_00
go
--exec chjer.dbo.eep_91d 980 
create procedure ep_91d_00
(
@menuflag char(20) 
)
--casper--
as
begin

update eep_nbak set remark = '1,'+isnull(remark,'')  where menuflag = @menuflag  

end 
GO

