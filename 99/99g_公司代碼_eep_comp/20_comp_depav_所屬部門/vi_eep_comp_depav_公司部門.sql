--USE [CASPER]
--GO
 
IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='eep_comp_depav')
   DROP VIEW eep_comp_depav
GO
CREATE VIEW eep_comp_depav as select compno , group1, group2 , depano , depanm    from .dbo.eep_depa
go
select  compno , group1, group2 , depano , depanm     from eep_comp_depav
go