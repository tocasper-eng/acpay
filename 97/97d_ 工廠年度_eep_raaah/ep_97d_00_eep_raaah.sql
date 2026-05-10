--USE  cfp 

--GO
--truncate table eep_raaa 
--truncate table eep_raaah 

--select * from eep_raaah 
--select * from eep_raaa 
--update dbo.eep_raaa set swt = 'Y' 
--where yyyy = 2025
--and  isnull(swt,'')='' 
--and  isnull(dw,0) > 6  

--select * from timer_eep 

--insert into eep_raaah (yyyy) values (2025)
--delete timer_eep 

-- exec ep_97d_00_eep_raaah '97D_00_0000000000001'

--select * from eep_raaa 

DROP PROCEDURE ep_97d_00_eep_raaah
GO

create procedure ep_97d_00_eep_raaah 
(
@menuflag char(20) 
)
--casper--
as
begin

declare @yyyy int   

select @yyyy = yyyy 
from eep_raaah 
where menuflag = @menuflag 


DECLARE @start_date DATE = DATEFROMPARTS(@yyyy, 1, 1);
DECLARE @end_date   DATE = DATEFROMPARTS(@yyyy, 12, 31);
DECLARE @d  DATE = @start_date;
DECLARE @dw TINYINT;
DECLARE @wk INT;

 

WHILE (@d <= @end_date)
BEGIN
    -- 計算星期（固定週一=1、...、週日=7），不受 SESSION 的 DATEFIRST 影響
    -- 1900-01-01 在 SQL Server 是星期一，因此可用日差對 7 取餘
    SET @dw = CAST((DATEDIFF(DAY, '19000101', @d) % 7) + 1 AS TINYINT);

    -- 週次使用 ISO 週（週一為週首，符合你要的「一周起始一定是週一」）
    SET @wk = DATEPART(ISO_WEEK, @d);

    -- 以單筆來源進行 MERGE（存在就更新，不存在就新增；不刪任何資料）
    MERGE dbo.eep_raaa AS T
    USING (SELECT @d AS dt, @dw AS dw, @wk AS wk , @yyyy as yyyy) AS S
        ON T.dt = S.dt
    WHEN MATCHED THEN
        UPDATE SET T.dw = S.dw, T.wk = S.wk
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (dt, dw, wk , yyyy) VALUES (S.dt, S.dw, S.wk , S.yyyy );

    SET @d = DATEADD(DAY, 1, @d);
END

update dbo.eep_raaa set swt = 'Y' 
where yyyy = @yyyy 
and  isnull(swt,'')='' 
and  isnull(dw,0) >= 6  

update dbo.eep_raaa set swt = 'N' 
where yyyy = @yyyy 
and  isnull(swt,'')<>'Y' 


end 






GO


