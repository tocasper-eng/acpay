use acpay 
go

if exists (select name from sysobjects where name = 'ep_62j_00')
   drop procedure ep_62j_00
go
--exec chjer.dbo.eep_a01_00 980 
create procedure ep_62j_00
(
@menuflag char(20) 
)
--casper--
as
begin
declare @int  int 

--update eep_iwh set remark = '1,'+isnull(remark,'')  where menuflag = @menuflag  

end 
GO

