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
--案件狀態代碼轉中文
case 案件狀態 when N'1' then N'待處理'
              when N'2' then N'處理中'
              when N'3' then N'已派工'
              when N'4' then N'已結案'
              else N'' end as 案件狀態名稱,
--結案方式代碼轉中文
case 結案方式 when N'1' then N'線上排除'
              when N'2' then N'派工完成'
              else N'' end as 結案方式名稱,
--案件分類代碼轉中文
case 案件分類 when N'1' then N'改菜單'
              when N'2' then N'操作教學及設定'
              when N'3' then N'電子發票'
              when N'4' then N'硬體設備故障'
              when N'5' then N'網路連線'
              when N'6' then N'系統帳務問題'
              when N'7' then N'耗材訂購'
              when N'8' then N'合約商務繳款'
              when N'9' then N'其他'
              else N'' end as 案件分類名稱,
*
FROM [eep_iwh]

 
go  
select * from eep_iwhv 
