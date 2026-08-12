--USE [gemio_wms]
--GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_recalc_itea]') AND type = N'P')
    DROP PROCEDURE [dbo].[sp_recalc_itea]
GO
CREATE PROCEDURE [dbo].[sp_recalc_itea]
AS
BEGIN
    SET NOCOUNT ON;

    -- =====================================================================
    -- This SP expects a temp table #affected with columns:
    --   itemno, posino, wareno, plantno, compno
    -- All hierarchy values come from mes_itio directly (not mes_level).
    --
    -- Logic:
    --   ioqty > 0 => InboundQuantity (入庫)
    --   ioqty < 0 => OutboundQuantity (出庫, stored as positive)
    --   OpeningQuantity = running sum of (Inbound - Outbound) up to previous day
    --   ClosingQuantity = OpeningQuantity + InboundQuantity - OutboundQuantity
    -- =====================================================================

    -- ==============================================================
    -- LEVEL 4: mes_itea4 (iodate, itemno, posino)
    -- ==============================================================
    DELETE t4
    FROM mes_itea4 t4
    INNER JOIN (SELECT DISTINCT itemno, posino FROM #affected) a
        ON t4.itemno = a.itemno AND t4.posino = a.posino;

    WITH daily4 AS (
        SELECT io.iodate, io.itemno, io.posino,
            SUM(CASE WHEN io.ioqty > 0 THEN io.ioqty ELSE 0 END) AS InboundQuantity,
            SUM(CASE WHEN io.ioqty < 0 THEN ABS(io.ioqty) ELSE 0 END) AS OutboundQuantity
        FROM mes_itio io
        INNER JOIN (SELECT DISTINCT itemno, posino FROM #affected) a
            ON io.itemno = a.itemno AND io.posino = a.posino
        GROUP BY io.iodate, io.itemno, io.posino
    ),
    running4 AS (
        SELECT iodate, itemno, posino,
            ISNULL(SUM(InboundQuantity - OutboundQuantity) OVER (
                PARTITION BY itemno, posino ORDER BY iodate
                ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
            ), 0) AS OpeningQuantity,
            InboundQuantity, OutboundQuantity,
            SUM(InboundQuantity - OutboundQuantity) OVER (
                PARTITION BY itemno, posino ORDER BY iodate
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS ClosingQuantity
        FROM daily4
    )
    INSERT INTO mes_itea4 (iodate, itemno, posino, OpeningQuantity, InboundQuantity, OutboundQuantity, ClosingQuantity)
    SELECT iodate, itemno, posino, OpeningQuantity, InboundQuantity, OutboundQuantity, ClosingQuantity
    FROM running4;

    -- ==============================================================
    -- LEVEL 3: mes_itea3 (iodate, itemno, wareno)
    -- ==============================================================
    DELETE t3
    FROM mes_itea3 t3
    INNER JOIN (SELECT DISTINCT itemno, wareno FROM #affected WHERE wareno IS NOT NULL) a
        ON t3.itemno = a.itemno AND t3.wareno = a.wareno;

    WITH daily3 AS (
        SELECT io.iodate, io.itemno, io.wareno,
            SUM(CASE WHEN io.ioqty > 0 THEN io.ioqty ELSE 0 END) AS InboundQuantity,
            SUM(CASE WHEN io.ioqty < 0 THEN ABS(io.ioqty) ELSE 0 END) AS OutboundQuantity
        FROM mes_itio io
        INNER JOIN (SELECT DISTINCT itemno, wareno FROM #affected WHERE wareno IS NOT NULL) a
            ON io.itemno = a.itemno AND io.wareno = a.wareno
        WHERE io.wareno IS NOT NULL
        GROUP BY io.iodate, io.itemno, io.wareno
    ),
    running3 AS (
        SELECT iodate, itemno, wareno,
            ISNULL(SUM(InboundQuantity - OutboundQuantity) OVER (
                PARTITION BY itemno, wareno ORDER BY iodate
                ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
            ), 0) AS OpeningQuantity,
            InboundQuantity, OutboundQuantity,
            SUM(InboundQuantity - OutboundQuantity) OVER (
                PARTITION BY itemno, wareno ORDER BY iodate
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS ClosingQuantity
        FROM daily3
    )
    INSERT INTO mes_itea3 (iodate, itemno, wareno, OpeningQuantity, InboundQuantity, OutboundQuantity, ClosingQuantity)
    SELECT iodate, itemno, wareno, OpeningQuantity, InboundQuantity, OutboundQuantity, ClosingQuantity
    FROM running3;

    -- ==============================================================
    -- LEVEL 2: mes_itea2 (iodate, itemno, plantno)
    -- ==============================================================
    DELETE t2
    FROM mes_itea2 t2
    INNER JOIN (SELECT DISTINCT itemno, plantno FROM #affected WHERE plantno IS NOT NULL) a
        ON t2.itemno = a.itemno AND t2.plantno = a.plantno;

    WITH daily2 AS (
        SELECT io.iodate, io.itemno, io.plantno,
            SUM(CASE WHEN io.ioqty > 0 THEN io.ioqty ELSE 0 END) AS InboundQuantity,
            SUM(CASE WHEN io.ioqty < 0 THEN ABS(io.ioqty) ELSE 0 END) AS OutboundQuantity
        FROM mes_itio io
        INNER JOIN (SELECT DISTINCT itemno, plantno FROM #affected WHERE plantno IS NOT NULL) a
            ON io.itemno = a.itemno AND io.plantno = a.plantno
        WHERE io.plantno IS NOT NULL
        GROUP BY io.iodate, io.itemno, io.plantno
    ),
    running2 AS (
        SELECT iodate, itemno, plantno,
            ISNULL(SUM(InboundQuantity - OutboundQuantity) OVER (
                PARTITION BY itemno, plantno ORDER BY iodate
                ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
            ), 0) AS OpeningQuantity,
            InboundQuantity, OutboundQuantity,
            SUM(InboundQuantity - OutboundQuantity) OVER (
                PARTITION BY itemno, plantno ORDER BY iodate
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS ClosingQuantity
        FROM daily2
    )
    INSERT INTO mes_itea2 (iodate, itemno, plantno, OpeningQuantity, InboundQuantity, OutboundQuantity, ClosingQuantity)
    SELECT iodate, itemno, plantno, OpeningQuantity, InboundQuantity, OutboundQuantity, ClosingQuantity
    FROM running2;

    -- ==============================================================
    -- LEVEL 1: mes_itea1 (iodate, itemno, compno)
    -- ==============================================================
    DELETE t1
    FROM mes_itea1 t1
    INNER JOIN (SELECT DISTINCT itemno, compno FROM #affected WHERE compno IS NOT NULL) a
        ON t1.itemno = a.itemno AND t1.compno = a.compno;

    WITH daily1 AS (
        SELECT io.iodate, io.itemno, io.compno,
            SUM(CASE WHEN io.ioqty > 0 THEN io.ioqty ELSE 0 END) AS InboundQuantity,
            SUM(CASE WHEN io.ioqty < 0 THEN ABS(io.ioqty) ELSE 0 END) AS OutboundQuantity
        FROM mes_itio io
        INNER JOIN (SELECT DISTINCT itemno, compno FROM #affected WHERE compno IS NOT NULL) a
            ON io.itemno = a.itemno AND io.compno = a.compno
        WHERE io.compno IS NOT NULL
        GROUP BY io.iodate, io.itemno, io.compno
    ),
    running1 AS (
        SELECT iodate, itemno, compno,
            ISNULL(SUM(InboundQuantity - OutboundQuantity) OVER (
                PARTITION BY itemno, compno ORDER BY iodate
                ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
            ), 0) AS OpeningQuantity,
            InboundQuantity, OutboundQuantity,
            SUM(InboundQuantity - OutboundQuantity) OVER (
                PARTITION BY itemno, compno ORDER BY iodate
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS ClosingQuantity
        FROM daily1
    )
    INSERT INTO mes_itea1 (iodate, itemno, compno, OpeningQuantity, InboundQuantity, OutboundQuantity, ClosingQuantity)
    SELECT iodate, itemno, compno, OpeningQuantity, InboundQuantity, OutboundQuantity, ClosingQuantity
    FROM running1;

    -- ==============================================================
    -- 最後一次異動日期的結果 => mes_mmbe1~4
    -- (#affected 為呼叫端建立的暫存表，巢狀 SP 可見)
    -- ==============================================================
    EXEC sp_recalc_mmbe;
END;
GO
