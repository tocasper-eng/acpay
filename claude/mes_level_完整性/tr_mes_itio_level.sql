-- =====================================================================
-- Trigger: tr_mes_itio_level
-- Table:   mes_itio
-- Event:   AFTER INSERT, UPDATE, DELETE
-- Purpose: 維持 mes_level 完整性
--          mes_level 記錄 mes_itio 中所有出現過的
--          (compno, plantno, wareno, posino) 組合。
--          INSERT/UPDATE 時新增缺少的組合；
--          DELETE/UPDATE 時移除已無對應 mes_itio 資料的組合。
--
-- 效能考量:
--   - INSERT 只對 inserted 做 DISTINCT 再 NOT EXISTS，不掃全表
--   - DELETE 只檢查 deleted 中涉及的組合，不掃全 mes_level
--   - 與 tr_mes_itio_sync 完全獨立，各自維護不同目標表
--
-- Collation:
--   tempdb 定序為 Chinese_Taiwan_Stroke_90_CI_AS，
--   acpay 為 Chinese_Taiwan_Stroke_CI_AS，
--   所有比對加 COLLATE 避免衝突。
-- =====================================================================
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_mes_itio_level')
    DROP TRIGGER [dbo].[tr_mes_itio_level]
GO
CREATE TRIGGER [dbo].[tr_mes_itio_level] ON [dbo].[mes_itio]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- ---------------------------------------------------------------
    -- 1. 新增：inserted 中出現但 mes_level 尚未有的組合
    --    (covers INSERT + UPDATE-new-side)
    -- ---------------------------------------------------------------
    INSERT INTO mes_level (compno, plantno, wareno, posino)
    SELECT DISTINCT i.compno, i.plantno, i.wareno, i.posino
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 FROM mes_level l
        WHERE l.compno  = i.compno  COLLATE Chinese_Taiwan_Stroke_CI_AS
          AND l.plantno = i.plantno COLLATE Chinese_Taiwan_Stroke_CI_AS
          AND l.wareno  = i.wareno  COLLATE Chinese_Taiwan_Stroke_CI_AS
          AND l.posino  = i.posino  COLLATE Chinese_Taiwan_Stroke_CI_AS
    );

    -- ---------------------------------------------------------------
    -- 2. 清除：deleted 中涉及的組合，若 mes_itio 已無任何對應資料則移除
    --    (covers DELETE + UPDATE-old-side)
    --    只檢查 deleted 涉及的組合，不掃描全表
    -- ---------------------------------------------------------------
    DELETE l
    FROM mes_level l
    INNER JOIN (
        SELECT DISTINCT compno, plantno, wareno, posino
        FROM deleted
    ) d ON  l.compno  = d.compno  COLLATE Chinese_Taiwan_Stroke_CI_AS
        AND l.plantno = d.plantno COLLATE Chinese_Taiwan_Stroke_CI_AS
        AND l.wareno  = d.wareno  COLLATE Chinese_Taiwan_Stroke_CI_AS
        AND l.posino  = d.posino  COLLATE Chinese_Taiwan_Stroke_CI_AS
    WHERE NOT EXISTS (
        SELECT 1 FROM mes_itio m
        WHERE m.compno  = l.compno  COLLATE Chinese_Taiwan_Stroke_CI_AS
          AND m.plantno = l.plantno COLLATE Chinese_Taiwan_Stroke_CI_AS
          AND m.wareno  = l.wareno  COLLATE Chinese_Taiwan_Stroke_CI_AS
          AND m.posino  = l.posino  COLLATE Chinese_Taiwan_Stroke_CI_AS
    );
END;
GO
