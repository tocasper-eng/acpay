use acpay 
go
--¥DÀÉ§ó·s
if exists (select name from sysobjects where name = 'ep_62j_post')
   drop procedure ep_62j_post
go
--exec chjer.dbo.eep_62j_01 980 
create procedure ep_62j_post
(
@menuflag char(20) 
)
--casper--
as
begin

exec .dbo.ep_62j_01 @menuflag 
exec .dbo.ep_62j_02 @menuflag 
exec .dbo.ep_62j_11 @menuflag 
exec .dbo.ep_62j_12 @menuflag 



end 
GO

