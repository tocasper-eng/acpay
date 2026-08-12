use acpay 
go
--•D¿…∂}©l
if exists (select name from sysobjects where name = 'ep_62k_01')
   drop procedure ep_62k_01
go
--exec chjer.dbo.eep_62k_01 980 
create procedure ep_62k_01
(
@menuflag char(20) 
)
--casper--
as
begin

declare @int int 

--update eep_trh  set 
--custnm   = eep_cust.custnm 
--from   eep_cust  
--where  eep_trh.menuflag          =  @menuflag
--and    eep_trh.custno            =  eep_cust.custno 
--and    eep_trh.custnm            <> eep_cust.custnm 

--update eep_trh  set 
--salenm = eep_sale.salenm 
--from   eep_sale  
--where  eep_trh.menuflag          =  @menuflag
--and    eep_trh.saleno            =  eep_sale.saleno 
--and    eep_trh.salenm            <> eep_sale.salenm 

end 
GO

