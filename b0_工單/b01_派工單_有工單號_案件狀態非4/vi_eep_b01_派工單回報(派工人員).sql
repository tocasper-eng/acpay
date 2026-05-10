--USE [CASPER]
--GO
 
IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='eep_b01')
   DROP VIEW eep_b01
GO
CREATE VIEW eep_b01 as select 
substring(chjernoz,1,1)+'/'+substring(chjernov,1,1) as flag,

* from .dbo.eep_iwh 
where isnull(工單編號,'')<>'' 
and substring(isnull(案件狀態,''),1,1) <> '4' 
and SUBSTRING(chjernoz,1,1)='Y' 

go
select top 1 *   from eep_b01
go