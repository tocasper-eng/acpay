--USE [CASPER]
--GO
 
IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='eep_coldef')
   DROP VIEW eep_coldef  
GO
CREATE VIEW eep_coldef  as 
select  TABLE_NAME, FIELD_NAME , CAPTION  from coldef 
go
 