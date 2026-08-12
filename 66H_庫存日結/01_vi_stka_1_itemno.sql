--USE [casper]
--GO
DROP VIEW stka_itemno
GO
CREATE VIEW stka_itemno 
as 
SELECT
iodate       ,
itemno     ,
sum(isnull(balance ,0)) as balance ,  
max(num)                as num  
from stka_itea  
group by iodate ,itemno  
GO
 