--USE [gemio_wms]
--GO
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_011_eep_tod_mes_itio')
    DROP TRIGGER [dbo].[tr_011_eep_tod_mes_itio]
GO
-- =====================================================================
-- Trigger: tr_111_eep_tod_mes_itio
-- Source:  eep_Tod (出庫單)
-- Target:  mes_itio
-- Mapping: iono=tono, ioseq=LEFT(toseq,4), ioseqseq='TOD '
--          ioqty = -ABS(toqty) (出庫為負)
--          posino = wareno (來源無 posino)
-- =====================================================================
CREATE TRIGGER [dbo].[tr_011_eep_tod_mes_itio]
ON [dbo].[eep_Tod]
AFTER   UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate wareno on INSERT/UPDATE
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        IF EXISTS (SELECT 1 FROM inserted WHERE wareno IS NULL OR RTRIM(wareno) = '')
        BEGIN
            RAISERROR(N'eep_Tod: wareno 不可為空', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
    END

    -- DELETE old mes_itio rows (DELETE and old side of UPDATE)
    DELETE io
    FROM mes_itio io
    INNER JOIN deleted d
        ON io.iono      = RTRIM(d.tono)
       AND io.ioseq     = LEFT(RTRIM(d.toseq), 4)
       AND io.ioseqseq  = 'TOD ';

    -- INSERT new mes_itio rows (INSERT and new side of UPDATE)
    INSERT INTO mes_itio (iono, ioseq, ioseqseq, iodate, itemno, posino, wareno, plantno, compno, ioqty)
    SELECT
        RTRIM(i.tono),
        LEFT(RTRIM(i.toseq), 4),
        'TOD ',
        CONVERT(char(8), i.todate, 112),
        RTRIM(i.itemno),
        RTRIM(i.wareno),                -- posino = wareno (來源無 posino)
        RTRIM(i.wareno),
        COALESCE(                        -- plantno 解析
            NULLIF(RTRIM(i.plantno), ''),
            RTRIM(w.plantno),
            RTRIM(i.wareno)
        ),
        COALESCE(                        -- compno 解析
            NULLIF(RTRIM(p.compno), ''),
            N'公司代碼'
        ),
        -ABS(ISNULL(i.toqty, 0))        -- 出庫 = 負數
    FROM inserted i
    LEFT JOIN eep_ware w
        ON RTRIM(i.wareno) = RTRIM(w.wareno)
    LEFT JOIN eep_plant p
        ON COALESCE(NULLIF(RTRIM(i.plantno),''), RTRIM(w.plantno)) = RTRIM(p.plantno);
END;
GO
