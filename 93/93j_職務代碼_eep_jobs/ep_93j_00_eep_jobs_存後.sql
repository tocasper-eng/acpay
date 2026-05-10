--use cfp 
--go

if exists (select name from sysobjects where name = 'eep_93j_00')
   drop procedure eep_93j_00
go
--exec chjer.dbo.eep_93j_00 980 
create procedure eep_93j_00
(
@menuflag char(20) 
)
--casper--
as
begin

  update eep_jobs set remark = '1,'+isnull(remark,'')  where menuflag = @menuflag  

end 
GO

