use cfp 
go

if exists (select name from sysobjects where name = 'eep_98m_00')
   drop procedure eep_98m_00
go
--exec chjer.dbo.eep_98m_00 980 
create procedure eep_98m_00
(
@menuflag char(20) 
)
--casper--
as
begin

  update eep_rth set remark = '1,'+isnull(remark,'')  where menuflag = @menuflag  

end 
GO

