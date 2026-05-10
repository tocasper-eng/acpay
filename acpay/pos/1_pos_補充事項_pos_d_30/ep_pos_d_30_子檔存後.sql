use cfp 
go

if exists (select name from sysobjects where name = 'ep_pos_d_30')
   drop procedure ep_pos_d_30
go
--exec chjer.dbo.eep_a01_20 980 
create procedure ep_pos_d_30
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

