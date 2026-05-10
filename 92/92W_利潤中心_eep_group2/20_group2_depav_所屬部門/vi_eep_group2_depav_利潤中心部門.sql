--USE [CASPER]
--GO
 
IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='eep_group2_depav')
   DROP VIEW eep_group2_depav
GO
CREATE VIEW eep_group2_depav as select group1,group2 , compno,depano , depanm   
from .dbo.eep_depa
go
select  group1 , group2 , compno , depano , depanm     from eep_group2_depav
go