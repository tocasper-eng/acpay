use acpay 
go
--select menuflag,* from eep_uuh 

if exists (select name from sysobjects where name = 'ep_69m_00')
   drop procedure ep_69m_00
go
--exec chjer.dbo.ep_69m_00 980 
create procedure ep_69m_00
(
@menuflag char(20) 
)
--casper--
as
begin
declare @int  int 

--update eep_uuh set remark = '1,'+isnull(remark,'')  where menuflag = @menuflag  

end 
GO

