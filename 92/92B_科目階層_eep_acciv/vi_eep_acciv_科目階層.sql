--USE [CASPER]
--GO
 
IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='eep_acciv')
   DROP VIEW eep_acciv
GO
CREATE VIEW eep_acciv as select * from .dbo.eep_acci
go
select top 1 *   from eep_acciv
go