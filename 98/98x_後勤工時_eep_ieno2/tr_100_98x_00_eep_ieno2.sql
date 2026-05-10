SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 直接使用 CREATE OR ALTER，如果 Trigger 已存在會自動覆蓋，不存在則建立
CREATE OR ALTER TRIGGER [dbo].[tr_100_98x_00_eep_ieno2] ON [dbo].[eep_ieno2]
AFTER INSERT 
AS
BEGIN 
    SET NOCOUNT ON;

    -- 使用內建函數取代自定義函數，提升 Set-based 運算效能
    UPDATE t
    SET t.menuflag = '98X_00_' + RIGHT('0000000000000' + CAST(i.num AS VARCHAR(13)), 13)
    FROM eep_ieno2 AS t
    INNER JOIN inserted AS i ON t.num = i.num;
END;
GO