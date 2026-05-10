use acpay
go
--主檔對下
if exists (select name from sysobjects where name = 'ep_a01_02')
   drop procedure ep_a01_02
go
--exec chjer.dbo.eep_a01_02 980 
create procedure ep_a01_02
(
@menuflag char(20) 
)
--casper--
as
begin
declare @iwno char(10) 

--11  77a 教學
--01  LLM 

--檔頭檔身各自獨立 num ,  chjernoi , chjernou , menuflag 
--若在iwd 要引用iwh的就要寫 num_iwh 
--以後關聯要靠單據編號

select @iwno = iwno from eep_iwh where menuflag=@menuflag  
update eep_iwd  set 
iwdate  = eep_iwh.iwdate,--報價日期上對下 
iwno2   = eep_iwh.iwno2 ,--客戶訂單上對下 
zoomno  = eep_iwh.zoomno,--單據類別上對下
custno  = eep_iwh.custno,--客戶代碼上對下
custnm  = eep_iwh.custnm,--客戶名稱上對下
saleno  = eep_iwh.saleno,--業務代碼上對下
salenm  = eep_iwh.salenm --業務名稱上對下
from   eep_iwh  
where  eep_iwd.iwno = @iwno
and    eep_iwh.iwno= eep_iwd.iwno

end 
GO

