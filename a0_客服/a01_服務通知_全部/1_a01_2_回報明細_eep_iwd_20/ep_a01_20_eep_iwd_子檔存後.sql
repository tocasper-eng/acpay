use cfp 
go

if exists (select name from sysobjects where name = 'ep_a01_20')
   drop procedure ep_a01_20
go
--exec chjer.dbo.eep_a01_20 980 
create procedure ep_a01_20
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

