use acpay 
go

if exists (select name from sysobjects where name = 'ep_93i_10')
   drop procedure ep_93i_10
go
--exec chjer.dbo.ep_93i_10 980 
create procedure ep_93i_10
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

