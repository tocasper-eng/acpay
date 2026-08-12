--USE [casper]
--GO
DROP VIEW stka_wareno
GO
CREATE VIEW stka_wareno 
as 
SELECT
iodate       ,
itemno     ,
wareno     ,
sum(isnull(balance ,0)) as balance ,  
max(num)                as num  
from stka_itea  
group by iodate ,itemno , wareno  
GO

 