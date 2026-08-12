use acpay 
go
--¥DÀÉ§ó·s
if exists (select name from sysobjects where name = 'ep_66d_post')
   drop procedure ep_66d_post
go
--exec chjer.dbo.eep_66d_01 980 
create procedure ep_66d_post
(
@menuflag char(20) 
)
--casper--
as
begin

exec .dbo.ep_66d_01 @menuflag 
exec .dbo.ep_66d_02 @menuflag 
exec .dbo.ep_66d_11 @menuflag 
exec .dbo.ep_66d_12 @menuflag 



end 
GO

