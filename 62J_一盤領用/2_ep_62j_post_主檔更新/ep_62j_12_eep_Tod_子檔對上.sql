use acpay 
go

if exists (select name from sysobjects where name = 'ep_62j_12')
   drop procedure ep_62j_12
go
--exec chjer.dbo.eep_62j_12 980 
create procedure ep_62j_12
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

--chjernoi
--UPDATE eep_toh
--SET 
--    eep_toh.tramt = ISNULL(d.tramt, 0),
--    eep_toh.trcnt = ISNULL(d.trcnt, 0)
--FROM eep_toh
--INNER JOIN (
--    SELECT 
--        tono,
--        SUM(isnull(tramt,0)) AS tramt,
--        count(*)             AS trcnt 
--    FROM eep_Tod
--	where tono = @tono
--    GROUP BY tono
--) AS d 
--ON eep_toh.tono = d.tono;


end 
GO

