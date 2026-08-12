--USE [gemio_wms]
--GO
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_mes_itio_sync')
    DROP TRIGGER [dbo].[tr_mes_itio_sync]
GO
CREATE TRIGGER [dbo].[tr_mes_itio_sync]  ON [dbo].[mes_itio]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- =====================================================================
    -- Trigger: tr_mes_itio_sync
    -- Purpose: When mes_itio changes (INSERT/UPDATE/DELETE),
    --          collect affected (itemno, posino, wareno, plantno, compno)
    --          and call sp_recalc_itea to recalculate all 4 itea levels.
    --
    -- Hierarchy values come from mes_itio directly (not mes_level).
    -- =====================================================================

    -- COLLATE: tempdb 定序為 Chinese_Taiwan_Stroke_90_CI_AS，
    --          acpay 為 Chinese_Taiwan_Stroke_CI_AS，
    --          temp table 須明確指定定序避免衝突。
    CREATE TABLE #affected (
        itemno  NVARCHAR(40) COLLATE Chinese_Taiwan_Stroke_CI_AS,
        posino  NVARCHAR(40) COLLATE Chinese_Taiwan_Stroke_CI_AS,
        wareno  NVARCHAR(40) COLLATE Chinese_Taiwan_Stroke_CI_AS,
        plantno NVARCHAR(40) COLLATE Chinese_Taiwan_Stroke_CI_AS,
        compno  NVARCHAR(40) COLLATE Chinese_Taiwan_Stroke_CI_AS
    );

    -- From deleted rows (covers DELETE and the "old" side of UPDATE)
    INSERT INTO #affected (itemno, posino, wareno, plantno, compno)
    SELECT DISTINCT itemno, posino, wareno, plantno, compno FROM deleted;

    -- From inserted rows (covers INSERT and the "new" side of UPDATE)
    INSERT INTO #affected (itemno, posino, wareno, plantno, compno)
    SELECT DISTINCT i.itemno, i.posino, i.wareno, i.plantno, i.compno
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 FROM #affected a
        WHERE a.itemno = i.itemno AND a.posino = i.posino
          AND ISNULL(a.wareno,'')  = ISNULL(i.wareno ,'')
          AND ISNULL(a.plantno,'') = ISNULL(i.plantno,'')
          AND ISNULL(a.compno,'')  = ISNULL(i.compno ,'')
    );

    -- Only proceed if there are affected rows
    IF EXISTS (SELECT 1 FROM #affected)
    BEGIN
        EXEC sp_recalc_itea;
    END

    DROP TABLE #affected;
END;
GO
