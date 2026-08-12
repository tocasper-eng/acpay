--USE [casper]
--GO
DROP VIEW stka_posino 
GO
CREATE VIEW stka_posino 
as 
SELECT
iodate       ,
itemno     ,
wareno     ,
posino     ,
sum(isnull(balance ,0)) as balance ,  
max(num)                as num  
from stka_itea  
group by iodate,itemno , wareno  , posino
GO

 