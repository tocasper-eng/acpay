--use cfp 
--go

if exists (select name from sysobjects where name = 'eep_92a_00')
   drop procedure eep_92a_00
go
--exec chjer.dbo.eep_92a 980 
create procedure eep_92a_00
(
@menuflag char(20) 
)
--casper--
as
begin

  update eep_acci set remark = '1,'+isnull(remark,'')  where menuflag = @menuflag  

  --exec chjer.dbo.us_a_exec_tsql @num , @menuflag
end 
GO

