use acpay 
go
--子檔開始
if exists (select name from sysobjects where name = 'ep_62k_11')
   drop procedure ep_62k_11
go
--exec chjer.dbo.eep_62k_11 980 
create procedure ep_62k_11
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
 
--UPDATE eep_trd set itemnm = eep_item.itemnm,
--                   unitno = eep_item.unitno
--from eep_item  
--where eep_trd.trno =  @trno
--and   eep_trd.itemno   =  eep_item.itemno
--and   eep_trd.itemnm   <> eep_item.itemnm 
 
--UPDATE eep_trd set unitno = eep_item.unitno 
--from eep_item  
--where eep_trd.trno =  @trno
--and   eep_trd.itemno   =  eep_item.itemno
--and   eep_trd.itemnm   <> eep_item.itemnm

--UPDATE eep_trd set trunitno = eep_item.unitno
--from eep_item  
--where eep_trd.trno =  @trno
--and   eep_trd.itemno   =  eep_item.itemno
--and   isnull(eep_trd.trunitno,'') = ''  

end 
GO

