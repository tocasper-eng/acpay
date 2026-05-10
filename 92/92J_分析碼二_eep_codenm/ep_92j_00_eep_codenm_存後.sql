--use cfp 
--go

if exists (select name from sysobjects where name = 'ep_92j_00')
   drop procedure ep_92j_00
go
--exec chjer.dbo.eep_92j 980 
create procedure ep_92j_00
(
@menuflag char(20) 
)
--casper--
as
begin

  update eep_codenm set remark = '1,'+isnull(remark,'')  where menuflag = @menuflag  

end 
GO

