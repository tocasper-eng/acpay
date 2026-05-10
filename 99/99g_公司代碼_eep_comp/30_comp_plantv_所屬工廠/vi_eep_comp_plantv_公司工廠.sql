--USE [CASPER]
--GO
 
IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='eep_comp_plantv')
   DROP VIEW eep_comp_plantv
GO
CREATE VIEW eep_comp_plantv as 
select compno , plantno ,plantnm  from .dbo.eep_plant 
go
select top 1 * from eep_comp_plantv
go