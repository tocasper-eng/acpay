use acpay 
go

if exists (select name from sysobjects where name = 'ep_62k_12')
   drop procedure ep_62k_12
go
--exec chjer.dbo.eep_62k_12 980 
create procedure ep_62k_12
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

--chjernoi
--UPDATE eep_trh
--SET 
--    eep_trh.tramt = ISNULL(d.tramt, 0),
--    eep_trh.trcnt = ISNULL(d.trcnt, 0)
--FROM eep_trh
--INNER JOIN (
--    SELECT 
--        trno,
--        SUM(isnull(tramt,0)) AS tramt,
--        count(*)             AS trcnt 
--    FROM eep_trd
--	where trno = @trno
--    GROUP BY trno
--) AS d 
--ON eep_trh.trno = d.trno;


end 
GO

