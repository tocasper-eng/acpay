use acpay 
go
--子檔開始
if exists (select name from sysobjects where name = 'ep_62j_11')
   drop procedure ep_62j_11
go
--exec chjer.dbo.eep_62j_11 980 
create procedure ep_62j_11
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
 
--UPDATE eep_Tod set itemnm = eep_item.itemnm,
--                   unitno = eep_item.unitno
--from eep_item  
--where eep_Tod.tono =  @tono
--and   eep_Tod.itemno   =  eep_item.itemno
--and   eep_Tod.itemnm   <> eep_item.itemnm 
 
--UPDATE eep_Tod set unitno = eep_item.unitno 
--from eep_item  
--where eep_Tod.tono =  @tono
--and   eep_Tod.itemno   =  eep_item.itemno
--and   eep_Tod.itemnm   <> eep_item.itemnm

--UPDATE eep_Tod set trunitno = eep_item.unitno
--from eep_item  
--where eep_Tod.tono =  @tono
--and   eep_Tod.itemno   =  eep_item.itemno
--and   isnull(eep_Tod.trunitno,'') = ''  

end 
GO

