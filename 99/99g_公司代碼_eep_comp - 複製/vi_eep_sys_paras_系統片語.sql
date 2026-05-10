--USE [CASPER]
--GO
 
IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='eep_sys_paras')
   DROP VIEW eep_sys_paras  
GO
CREATE VIEW eep_sys_paras  as 
select  * from sys_paras
go
--select top 1 *   from eep_sys_paras 
--go

--select  menuid , caption , parent , form , itemtype , seq_no from MENUTABLE 
--order by itemtype , MENUID 

 
ALTER TABLE sys_paras ADD PRIMARY KEY (columnname   );
