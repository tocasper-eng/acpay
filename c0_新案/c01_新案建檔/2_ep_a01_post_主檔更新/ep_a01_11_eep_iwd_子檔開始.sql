use acpay 
go
--子檔開始
if exists (select name from sysobjects where name = 'ep_a01_11')
   drop procedure ep_a01_11
go
--exec chjer.dbo.eep_a01_11 980 
create procedure ep_a01_11
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
 
--UPDATE eep_iwd set itemnm = eep_item.itemnm,
--                   unitno = eep_item.unitno
--from eep_item  
--where eep_iwd.iwno =  @iwno
--and   eep_iwd.itemno   =  eep_item.itemno
--and   eep_iwd.itemnm   <> eep_item.itemnm 
 
--UPDATE eep_iwd set unitno = eep_item.unitno 
--from eep_item  
--where eep_iwd.iwno =  @iwno
--and   eep_iwd.itemno   =  eep_item.itemno
--and   eep_iwd.itemnm   <> eep_item.itemnm

--UPDATE eep_iwd set iwunitno = eep_item.unitno
--from eep_item  
--where eep_iwd.iwno =  @iwno
--and   eep_iwd.itemno   =  eep_item.itemno
--and   isnull(eep_iwd.iwunitno,'') = ''  

end 
GO

