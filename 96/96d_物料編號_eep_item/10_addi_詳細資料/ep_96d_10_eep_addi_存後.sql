use acpay 
go

if exists (select name from sysobjects where name = 'ep_96d_10')
   drop procedure ep_96d_10
go
--exec chjer.dbo.eep_96d_10 980 
create procedure ep_96d_10
(
@menuflag char(20) 
)
--casper--
as
begin
declare @int int 

--update eep_qtd set remark = '1,'+isnull(remark,'')  where menuflag = @menuflag  

end 
GO

