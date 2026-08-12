use acpay
go
--主檔對下
if exists (select name from sysobjects where name = 'ep_62j_02')
   drop procedure ep_62j_02
go
--exec chjer.dbo.eep_62j_02 980 
create procedure ep_62j_02
(
@menuflag char(20) 
)
--casper--
as
begin
declare @tono char(10) 

--11  77a 教學
--01  LLM 

--檔頭檔身各自獨立 num ,  chjernoi , chjernou , menuflag 
--若在Tod 要引用toh的就要寫 num_toh 
--以後關聯要靠單據編號

select @tono = tono from eep_toh where menuflag=@menuflag  
update eep_Tod  set 
trdate   = eep_toh.trdate ,--單據日期上對下 
trno2    = eep_toh.trno2  ,--相關編號單上對下 
zoomno   = eep_toh.zoomno ,--單據類別上對下
emplno   = eep_toh.emplno ,--員工代碼上對下
emplnm   = eep_toh.emplnm ,--員工名稱上對下
plantno  = eep_toh.plantno,--工廠代碼上對下
plantnm  = eep_toh.plantnm --工廠名稱上對下
from   eep_toh  
where  eep_Tod.tono = @tono
and    eep_toh.tono= eep_Tod.tono

end 
GO

