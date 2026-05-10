--use cfp 
--go
if exists (select name from sysobjects where name = 'ep_91c_00')
   drop procedure ep_91c_00
go
--exec chjer.dbo.eep_91c_00 980 
create procedure ep_91c_00
(
@menuflag char(20) 
)
--casper--
as
begin
declare @int int 

--update eep_curr set remark = '1,'+isnull(remark,'')  where menuflag = @menuflag  

end 
GO

