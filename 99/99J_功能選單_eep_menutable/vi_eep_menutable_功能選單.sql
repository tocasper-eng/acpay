--USE [CASPER]
--GO
 
IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='eep_menutable')
   DROP VIEW eep_menutable  
GO
CREATE VIEW eep_menutable  as 
select  menuid , caption , parent , form , itemtype , seq_no , moduletype from MENUTABLE 
go
select top 1 *   from eep_menutable 
go

--select  menuid , caption , parent , form , itemtype , seq_no from MENUTABLE 
--order by itemtype , MENUID 

--ALTER TABLE menutable ADD PRIMARY KEY ( menuid);
