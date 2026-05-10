use acpay 
go
--•D¿…∂}©l
if exists (select name from sysobjects where name = 'ep_a01_01')
   drop procedure ep_a01_01
go
--exec chjer.dbo.eep_a01_01 980 
create procedure ep_a01_01
(
@menuflag char(20) 
)
--casper--
as
begin

update eep_iwh  set 
custnm   = eep_cust.custnm 
from   eep_cust  
where  eep_iwh.menuflag          =  @menuflag
and    eep_iwh.custno            =  eep_cust.custno 
and    eep_iwh.custnm            <> eep_cust.custnm 

update eep_iwh  set 
salenm = eep_sale.salenm 
from   eep_sale  
where  eep_iwh.menuflag          =  @menuflag
and    eep_iwh.saleno            =  eep_sale.saleno 
and    eep_iwh.salenm            <> eep_sale.salenm 

end 
GO

