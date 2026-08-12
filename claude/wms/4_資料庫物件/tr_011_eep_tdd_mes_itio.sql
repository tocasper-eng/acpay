--USE [gemio_wms]
--GO
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_011_eep_tdd_mes_itio')
    DROP TRIGGER [dbo].[tr_011_eep_tdd_mes_itio]
GO
-- =====================================================================
-- Trigger: tr_111_eep_tdd_mes_itio
-- Source:  eep_tdd (調撥單)
-- Target:  mes_itio (每筆產生 2 列: TDDO 出庫 + TDDI 入庫)
-- Mapping: iono=tdno, ioseq=LEFT(tdseq,4)
--          ioseqseq='TDDO' 出庫(warenofm), ioqty=-ABS(tdqty)
--          ioseqseq='TDDI' 入庫(warenoto), ioqty=+ABS(tdqty)
--          posino = wareno (來源無 posino)
-- =====================================================================
CREATE TRIGGER [dbo].[tr_011_eep_tdd_mes_itio]
ON [dbo].[eep_tdd]
AFTER   UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate warenofm and warenoto on INSERT/UPDATE
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        IF EXISTS (SELECT 1 FROM inserted WHERE warenofm IS NULL OR RTRIM(warenofm) = '')
        BEGIN
            RAISERROR(N'eep_tdd: warenofm 不可為空', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        IF EXISTS (SELECT 1 FROM inserted WHERE warenoto IS NULL OR RTRIM(warenoto) = '')
        BEGIN
            RAISERROR(N'eep_tdd: warenoto 不可為空', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
    END

    -- DELETE old mes_itio rows (both TDDO and TDDI)
    DELETE io
    FROM mes_itio io
    INNER JOIN deleted d
        ON io.iono      = RTRIM(d.tdno)
       AND io.ioseq     = LEFT(RTRIM(d.tdseq), 4)
       AND io.ioseqseq  IN ('TDDO', 'TDDI');

    -- INSERT outbound row (TDDO): 從 warenofm 出庫
    INSERT INTO mes_itio (iono, ioseq, ioseqseq, iodate, itemno, posino, wareno, plantno, compno, ioqty)
    SELECT
        RTRIM(i.tdno),
        LEFT(RTRIM(i.tdseq), 4),
        'TDDO',
        CONVERT(char(8), i.tddate, 112),
        RTRIM(i.itemno),
        RTRIM(i.warenofm),              -- posino = warenofm
        RTRIM(i.warenofm),
        COALESCE(
            NULLIF(RTRIM(i.plantno), ''),
            RTRIM(wfm.plantno),
            RTRIM(i.warenofm)
        ),
        COALESCE(
            NULLIF(RTRIM(pfm.compno), ''),
            N'公司代碼'
        ),
        -ABS(ISNULL(i.tdqty, 0))        -- 出庫 = 負數
    FROM inserted i
    LEFT JOIN eep_ware wfm
        ON RTRIM(i.warenofm) = RTRIM(wfm.wareno)
    LEFT JOIN eep_plant pfm
        ON COALESCE(NULLIF(RTRIM(i.plantno),''), RTRIM(wfm.plantno)) = RTRIM(pfm.plantno);

    -- INSERT inbound row (TDDI): 入 warenoto 入庫
    INSERT INTO mes_itio (iono, ioseq, ioseqseq, iodate, itemno, posino, wareno, plantno, compno, ioqty)
    SELECT
        RTRIM(i.tdno),
        LEFT(RTRIM(i.tdseq), 4),
        'TDDI',
        CONVERT(char(8), i.tddate, 112),
        RTRIM(i.itemno),
        RTRIM(i.warenoto),              -- posino = warenoto
        RTRIM(i.warenoto),
        COALESCE(
            NULLIF(RTRIM(i.plantno), ''),
            RTRIM(wto.plantno),
            RTRIM(i.warenoto)
        ),
        COALESCE(
            NULLIF(RTRIM(pto.compno), ''),
            N'公司代碼'
        ),
        ABS(ISNULL(i.tdqty, 0))         -- 入庫 = 正數
    FROM inserted i
    LEFT JOIN eep_ware wto
        ON RTRIM(i.warenoto) = RTRIM(wto.wareno)
    LEFT JOIN eep_plant pto
        ON COALESCE(NULLIF(RTRIM(i.plantno),''), RTRIM(wto.plantno)) = RTRIM(pto.plantno);
END;
GO
