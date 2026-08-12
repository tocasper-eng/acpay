use acpay 
go
--•D¿…∂}©l
if exists (select name from sysobjects where name = 'ep_62j_01')
   drop procedure ep_62j_01
go
--exec chjer.dbo.eep_62j_01 980 
create procedure ep_62j_01
(
@menuflag char(20) 
)
--casper--
as
begin

declare @int int 

--update eep_toh  set 
--custnm   = eep_cust.custnm 
--from   eep_cust  
--where  eep_toh.menuflag          =  @menuflag
--and    eep_toh.custno            =  eep_cust.custno 
--and    eep_toh.custnm            <> eep_cust.custnm 

--update eep_toh  set 
--salenm = eep_sale.salenm 
--from   eep_sale  
--where  eep_toh.menuflag          =  @menuflag
--and    eep_toh.saleno            =  eep_sale.saleno 
--and    eep_toh.salenm            <> eep_sale.salenm 

end 
GO

