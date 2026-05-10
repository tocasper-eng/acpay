use acpay 
go

if exists (select name from sysobjects where name = 'ep_a01_12')
   drop procedure ep_a01_12
go
--exec chjer.dbo.eep_a01_12 980 
create procedure ep_a01_12
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

--chjernoi
--UPDATE eep_iwh
--SET 
--    eep_iwh.iwamt = ISNULL(d.iwamt, 0),
--    eep_iwh.iwcnt = ISNULL(d.iwcnt, 0)
--FROM eep_iwh
--INNER JOIN (
--    SELECT 
--        iwno,
--        SUM(isnull(iwamt,0)) AS iwamt,
--        count(*)             AS iwcnt 
--    FROM eep_iwd
--	where iwno = @iwno
--    GROUP BY iwno
--) AS d 
--ON eep_iwh.iwno = d.iwno;


end 
GO

