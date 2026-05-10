--use cfp 
--go

if exists (select name from sysobjects where name = 'eep_92i_00')
   drop procedure eep_92i_00
go
--exec chjer.dbo.eep_92i_00 980 
create procedure eep_92i_00
(
@menuflag char(20) 
)
--casper--
as
begin

  update eep_codeno set remark = '1,'+isnull(remark,'')  where menuflag = @menuflag  

end 
GO

