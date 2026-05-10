USE acpay 

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE acpay;
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER TRIGGER [dbo].[tr_100_69m_00_eep_uuh] ON [dbo].[eep_uuh]
AFTER INSERT 
AS
BEGIN 
    SET NOCOUNT ON;

    -- 定義今天的日期字串 (YYYYMMDD)
    DECLARE @Today VARCHAR(8) = CONVERT(VARCHAR(8), GETDATE(), 112);

    -- 取得目前資料表中，今日已存在的最大流水號
    DECLARE @MaxSeq INT;
    SELECT @MaxSeq = ISNULL(MAX(CAST(RIGHT(wuno, 4) AS INT)), 0)
    FROM eep_uuh
    WHERE wuno LIKE @Today + '%';

    -- 更新資料
    UPDATE t
    SET 
        t.menuflag = '98X_00_' + RIGHT('0000000000000' + CAST(i.num AS VARCHAR(13)), 13),
        -- 邏輯：今日日期 + (現有最大序號 + 該批次的列號)
        t.wuno = @Today + RIGHT('0000' + CAST(@MaxSeq + i.RowNum AS VARCHAR(4)), 4)
    FROM eep_uuh AS t
    INNER JOIN (
        -- 使用 ROW_NUMBER 處理「一次新增多筆」的情況
        SELECT num, ROW_NUMBER() OVER (ORDER BY num) AS RowNum
        FROM inserted
    ) AS i ON t.num = i.num;
END;
GO

GO


