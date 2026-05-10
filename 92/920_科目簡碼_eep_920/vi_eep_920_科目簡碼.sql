 ----select *   from eep_acciv 
 ----
 ----可以幫我建一個 cross table 的 view ，
 ----
 --insert into eep_acci(accino,accinm) values ( '110011','121313') 
 --insert into eep_acci(accino,accinm) values ( '310011','121313') 
 --insert into eep_acci(accino,accinm) values ( '210011','121313') 
 --insert into eep_acci(accino,accinm) values ( '120011','121313') 
 --insert into eep_acci(accino,accinm) values ( '120031','121313') 
 ----
 --select * from eep_920

 --橫軸是  substring(accino,1,2)
 --縱軸是  substring(accino,3,4)
IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='eep_920')
   DROP VIEW eep_920
GO
CREATE VIEW eep_920
AS
SELECT *
FROM (
    SELECT 
        SUBSTRING(accino, 3, 4) AS row_id,   -- 縱軸
        SUBSTRING(accino, 1, 2) AS col_id,   -- 橫軸
        1 AS val
    FROM eep_acci
) AS src
PIVOT (
    COUNT(val) FOR col_id IN (
	[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],
	[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],
	[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],
	[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],
	[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],
	[51],[52],[53],[54],[55],[56],[57],[58],[59],[60],
	[61],[62],[63],[64],[65],[66],[67],[68],[69],[70],
	[71],[72],[73],[74],[75],[76],[77],[78],[79],[80],
	[81],[82],[83],[84],[85],[86],[87],[88],[89],[90],
	[91],[92],[93],[94],[95],[96],[97],[98],[99],[00] 
	)
) AS p;
