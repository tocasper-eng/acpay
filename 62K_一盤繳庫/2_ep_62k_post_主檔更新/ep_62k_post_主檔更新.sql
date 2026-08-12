use acpay 
go
--¥DÀÉ§ó·s
if exists (select name from sysobjects where name = 'ep_62k_post')
   drop procedure ep_62k_post
go
--exec chjer.dbo.eep_62k_01 980 
create procedure ep_62k_post
(
@menuflag char(20) 
)
--casper--
as
begin

exec .dbo.ep_62k_01 @menuflag 
exec .dbo.ep_62k_02 @menuflag 
exec .dbo.ep_62k_11 @menuflag 
exec .dbo.ep_62k_12 @menuflag 



end 
GO

