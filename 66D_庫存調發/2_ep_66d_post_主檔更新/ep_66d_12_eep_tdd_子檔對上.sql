use acpay 
go

if exists (select name from sysobjects where name = 'ep_66d_12')
   drop procedure ep_66d_12
go
--exec chjer.dbo.eep_66d_12 980 
create procedure ep_66d_12
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

--chjernoi
--UPDATE eep_tdh
--SET 
--    eep_tdh.tdamt = ISNULL(d.tdamt, 0),
--    eep_tdh.tdcnt = ISNULL(d.tdcnt, 0)
--FROM eep_tdh
--INNER JOIN (
--    SELECT 
--        tdno,
--        SUM(isnull(tdamt,0)) AS tdamt,
--        count(*)             AS tdcnt 
--    FROM eep_tdd
--	where tdno = @tdno
--    GROUP BY tdno
--) AS d 
--ON eep_tdh.tdno = d.tdno;


end 
GO

