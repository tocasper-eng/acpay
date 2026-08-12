use acpay
go
--主檔對下
if exists (select name from sysobjects where name = 'ep_62k_02')
   drop procedure ep_62k_02
go
--exec chjer.dbo.eep_62k_02 980 
create procedure ep_62k_02
(
@menuflag char(20) 
)
--casper--
as
begin
declare @trno char(10) 

--11  77a 教學
--01  LLM 

--檔頭檔身各自獨立 num ,  chjernoi , chjernou , menuflag 
--若在trd 要引用trh的就要寫 num_trh 
--以後關聯要靠單據編號

select @trno = trno from eep_trh where menuflag=@menuflag  
update eep_trd  set 
trdate   = eep_trh.trdate ,--單據日期上對下 
trno2    = eep_trh.trno2  ,--相關編號單上對下 
zoomno   = eep_trh.zoomno ,--單據類別上對下
emplno   = eep_trh.emplno ,--員工代碼上對下
emplnm   = eep_trh.emplnm ,--員工名稱上對下
plantno  = eep_trh.plantno,--工廠代碼上對下
plantnm  = eep_trh.plantnm --工廠名稱上對下
from   eep_trh  
where  eep_trd.trno = @trno
and    eep_trh.trno= eep_trd.trno

end 
GO

