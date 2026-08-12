--USE [casper]
--GO
DROP VIEW stka_wareswt 
GO
CREATE VIEW stka_wareswt 
as 
SELECT
iodate      ,
itemno     ,
wareno     ,
posino     ,
wareswt    ,
sum(isnull(balance ,0)) as balance ,  
max(num)                as num  
from stka_itea  
group by iodate ,itemno , wareno  , posino ,wareswt
GO
 