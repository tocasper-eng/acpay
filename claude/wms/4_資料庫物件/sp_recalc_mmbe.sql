--USE [gemio_wms]
--GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_recalc_mmbe]') AND type = N'P')
    DROP PROCEDURE [dbo].[sp_recalc_mmbe]
GO
CREATE PROCEDURE [dbo].[sp_recalc_mmbe]
AS
BEGIN
    SET NOCOUNT ON;

    -- =====================================================================
    -- sp_recalc_mmbe
    --
    -- 將 mes_itea1~4「最後一次異動日期」那一列寫入 mes_mmbe1~4。
    --
    -- 前置條件：呼叫端已建立 #affected (itemno, posino, wareno, plantno, compno)
    --           且 sp_recalc_itea 已重算完 mes_itea1~4。
    --
    -- key 只有 (itemno, 階層碼)，所以每個組合最多一列。
    -- iodate 為 char(8) 'YYYYMMDD'，字典序 = 時間序，MAX() 即最後異動日。
    -- 該組合在 mes_itea* 已無任何列時（來源全被刪除），mmbe 列一併移除。
    -- =====================================================================

    -- ==============================================================
    -- LEVEL 4: mes_mmbe4 (itemno, posino)
    -- ==============================================================
    DELETE m
    FROM mes_mmbe4 m
    INNER JOIN (SELECT DISTINCT itemno, posino FROM #affected WHERE posino IS NOT NULL) a
        ON m.itemno = a.itemno AND m.posino = a.posino;

    INSERT INTO mes_mmbe4 (itemno, posino, OpeningQuantity, InboundQuantity, OutboundQuantity, ClosingQuantity)
    SELECT t.itemno, t.posino, t.OpeningQuantity, t.InboundQuantity, t.OutboundQuantity, t.ClosingQuantity
    FROM mes_itea4 t
    INNER JOIN (SELECT DISTINCT itemno, posino FROM #affected WHERE posino IS NOT NULL) a
        ON t.itemno = a.itemno AND t.posino = a.posino
    WHERE t.iodate = (SELECT MAX(x.iodate) FROM mes_itea4 x
                      WHERE x.itemno = t.itemno AND x.posino = t.posino);

    -- ==============================================================
    -- LEVEL 3: mes_mmbe3 (itemno, wareno)
    -- ==============================================================
    DELETE m
    FROM mes_mmbe3 m
    INNER JOIN (SELECT DISTINCT itemno, wareno FROM #affected WHERE wareno IS NOT NULL) a
        ON m.itemno = a.itemno AND m.wareno = a.wareno;

    INSERT INTO mes_mmbe3 (itemno, wareno, OpeningQuantity, InboundQuantity, OutboundQuantity, ClosingQuantity)
    SELECT t.itemno, t.wareno, t.OpeningQuantity, t.InboundQuantity, t.OutboundQuantity, t.ClosingQuantity
    FROM mes_itea3 t
    INNER JOIN (SELECT DISTINCT itemno, wareno FROM #affected WHERE wareno IS NOT NULL) a
        ON t.itemno = a.itemno AND t.wareno = a.wareno
    WHERE t.iodate = (SELECT MAX(x.iodate) FROM mes_itea3 x
                      WHERE x.itemno = t.itemno AND x.wareno = t.wareno);

    -- ==============================================================
    -- LEVEL 2: mes_mmbe2 (itemno, plantno)
    -- ==============================================================
    DELETE m
    FROM mes_mmbe2 m
    INNER JOIN (SELECT DISTINCT itemno, plantno FROM #affected WHERE plantno IS NOT NULL) a
        ON m.itemno = a.itemno AND m.plantno = a.plantno;

    INSERT INTO mes_mmbe2 (itemno, plantno, OpeningQuantity, InboundQuantity, OutboundQuantity, ClosingQuantity)
    SELECT t.itemno, t.plantno, t.OpeningQuantity, t.InboundQuantity, t.OutboundQuantity, t.ClosingQuantity
    FROM mes_itea2 t
    INNER JOIN (SELECT DISTINCT itemno, plantno FROM #affected WHERE plantno IS NOT NULL) a
        ON t.itemno = a.itemno AND t.plantno = a.plantno
    WHERE t.iodate = (SELECT MAX(x.iodate) FROM mes_itea2 x
                      WHERE x.itemno = t.itemno AND x.plantno = t.plantno);

    -- ==============================================================
    -- LEVEL 1: mes_mmbe1 (itemno, compno)
    -- ==============================================================
    DELETE m
    FROM mes_mmbe1 m
    INNER JOIN (SELECT DISTINCT itemno, compno FROM #affected WHERE compno IS NOT NULL) a
        ON m.itemno = a.itemno AND m.compno = a.compno;

    INSERT INTO mes_mmbe1 (itemno, compno, OpeningQuantity, InboundQuantity, OutboundQuantity, ClosingQuantity)
    SELECT t.itemno, t.compno, t.OpeningQuantity, t.InboundQuantity, t.OutboundQuantity, t.ClosingQuantity
    FROM mes_itea1 t
    INNER JOIN (SELECT DISTINCT itemno, compno FROM #affected WHERE compno IS NOT NULL) a
        ON t.itemno = a.itemno AND t.compno = a.compno
    WHERE t.iodate = (SELECT MAX(x.iodate) FROM mes_itea1 x
                      WHERE x.itemno = t.itemno AND x.compno = t.compno);
END;
GO
