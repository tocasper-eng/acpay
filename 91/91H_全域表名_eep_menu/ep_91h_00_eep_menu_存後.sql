--use cfp 
--go
if exists (select name from sysobjects where name = 'ep_91h_00')
   drop procedure ep_91h_00
go
--exec chjer.dbo.ep_91h_00 980 
create procedure ep_91h_00
(
@menuflag char(20) 
)
--casper--
as
begin

declare @int int 

--update eep_nnban set remark = '1,'+isnull(remark,'')  where menuflag = @menuflag  

end 
GO

