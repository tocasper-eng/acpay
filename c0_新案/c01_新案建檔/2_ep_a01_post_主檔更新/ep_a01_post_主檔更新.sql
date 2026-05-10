use acpay 
go
--¥DÀÉ§ó·s
if exists (select name from sysobjects where name = 'ep_a01_post')
   drop procedure ep_a01_post
go
--exec chjer.dbo.eep_a01_01 980 
create procedure ep_a01_post
(
@menuflag char(20) 
)
--casper--
as
begin

exec .dbo.ep_a01_01 @menuflag 
exec .dbo.ep_a01_02 @menuflag 
exec .dbo.ep_a01_11 @menuflag 
exec .dbo.ep_a01_12 @menuflag 



end 
GO

