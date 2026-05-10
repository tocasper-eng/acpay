use acpay 
go
IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='eep_iwhv ')
   DROP VIEW eep_iwhv 
GO 
CREATE VIEW eep_iwhv     AS 
  
SELECT 
case when substring(ISNULL(chjernoc,''),1,1)<>'Y' then 'N' else 'Y' end as flagc, 
case when substring(ISNULL(chjernov,''),1,1)<>'Y' then 'N' else 'Y' end as flagv, 
substring(chjernoz,1,1)+'/'+substring(chjernoc,1,1)+'/'+substring(chjernov,1,1) as flag,
* 
FROM [eep_iwh]

 
go  
select * from eep_iwhv 
