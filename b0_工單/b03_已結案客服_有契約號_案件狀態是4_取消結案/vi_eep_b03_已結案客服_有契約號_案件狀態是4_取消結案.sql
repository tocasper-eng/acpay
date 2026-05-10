--USE [CASPER]
--GO
 
IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='eep_b03')
   DROP VIEW eep_b03
GO
CREATE VIEW eep_b03 as select * from .dbo.eep_iwh 
where isnull(契約編號,'') <> '' 
and substring(isnull(案件狀態,''),1,1) = '4' 
go
select top 1 *   from eep_b03
go