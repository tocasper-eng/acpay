use acpay 
go
--子檔開始
if exists (select name from sysobjects where name = 'ep_66d_11')
   drop procedure ep_66d_11
go
--exec chjer.dbo.eep_66d_11 980 
create procedure ep_66d_11
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
 
--UPDATE eep_tdd set itemnm = eep_item.itemnm,
--                   unitno = eep_item.unitno
--from eep_item  
--where eep_tdd.tdno =  @tdno
--and   eep_tdd.itemno   =  eep_item.itemno
--and   eep_tdd.itemnm   <> eep_item.itemnm 
 
--UPDATE eep_tdd set unitno = eep_item.unitno 
--from eep_item  
--where eep_tdd.tdno =  @tdno
--and   eep_tdd.itemno   =  eep_item.itemno
--and   eep_tdd.itemnm   <> eep_item.itemnm

--UPDATE eep_tdd set tdunitno = eep_item.unitno
--from eep_item  
--where eep_tdd.tdno =  @tdno
--and   eep_tdd.itemno   =  eep_item.itemno
--and   isnull(eep_tdd.tdunitno,'') = ''  

end 
GO

