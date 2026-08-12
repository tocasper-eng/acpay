use acpay
go
--主檔對下
if exists (select name from sysobjects where name = 'ep_66d_02')
   drop procedure ep_66d_02
go
--exec chjer.dbo.eep_66d_02 980 
create procedure ep_66d_02
(
@menuflag char(20) 
)
--casper--
as
begin
declare @tdno char(10) 

--11  77a 教學
--01  LLM 

--檔頭檔身各自獨立 num ,  chjernoi , chjernou , menuflag 
--若在tdd 要引用tdh的就要寫 num_tdh 
--以後關聯要靠單據編號

select @tdno = tdno from eep_tdh where menuflag=@menuflag  
update eep_tdd  set 
tddate   = eep_tdh.tddate ,--單據日期上對下 
tdno2    = eep_tdh.tdno2  ,--相關編號單上對下 
zoomno   = eep_tdh.zoomno ,--單據類別上對下
emplno   = eep_tdh.emplno ,--員工代碼上對下
emplnm   = eep_tdh.emplnm ,--員工名稱上對下
plantno  = eep_tdh.plantno,--工廠代碼上對下
plantnm  = eep_tdh.plantnm --工廠名稱上對下
from   eep_tdh  
where  eep_tdd.tdno = @tdno
and    eep_tdh.tdno= eep_tdd.tdno

end 
GO

