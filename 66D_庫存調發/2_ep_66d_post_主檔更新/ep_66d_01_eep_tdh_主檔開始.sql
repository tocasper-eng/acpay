use acpay 
go
--•D¿…∂}©l
if exists (select name from sysobjects where name = 'ep_66d_01')
   drop procedure ep_66d_01
go
--exec chjer.dbo.eep_66d_01 980 
create procedure ep_66d_01
(
@menuflag char(20) 
)
--casper--
as
begin

declare @int int 

--update eep_tdh  set 
--custnm   = eep_cust.custnm 
--from   eep_cust  
--where  eep_tdh.menuflag          =  @menuflag
--and    eep_tdh.custno            =  eep_cust.custno 
--and    eep_tdh.custnm            <> eep_cust.custnm 

--update eep_tdh  set 
--salenm = eep_sale.salenm 
--from   eep_sale  
--where  eep_tdh.menuflag          =  @menuflag
--and    eep_tdh.saleno            =  eep_sale.saleno 
--and    eep_tdh.salenm            <> eep_sale.salenm 

end 
GO

