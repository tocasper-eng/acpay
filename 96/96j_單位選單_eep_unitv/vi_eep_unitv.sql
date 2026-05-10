--use cfp 
--go 

IF EXISTS(SELECT name FROM sysobjects WHERE name='eep_unitv')
   DROP VIEW eep_unitv
GO  
CREATE VIEW eep_unitv
as
select 
unitno                ,--單位代碼
max(remark) as remark ,--單位說明
count(*)    as cnt     --筆數
from eep_unit
group by unitno 
go
