--USE [CASPER]
--GO
 
IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='eep_a02')
   DROP VIEW eep_a02
GO
CREATE VIEW eep_a02 as select * from .dbo.eep_iwh 
where isnull(契約編號,'') = '' 
and substring(isnull(案件狀態,''),1,1) <>'4' 
and substring(ISNULL(chjernoc,''),1,1) <> 'Y' 

go
select top 1 *   from eep_a02
go