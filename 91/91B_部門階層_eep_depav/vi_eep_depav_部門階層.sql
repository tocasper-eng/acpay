--USE [CASPER]
--GO
 
IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='eep_depav')
   DROP VIEW eep_depav
GO
CREATE VIEW eep_depav as select * from .dbo.eep_depa
go
select top 1 *   from eep_depav
go