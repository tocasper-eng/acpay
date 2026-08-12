--USE [gemio_wms]
--GO
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_011_eep_trd_mes_itio')
    DROP TRIGGER [dbo].[tr_011_eep_trd_mes_itio]
GO
-- =====================================================================
-- Trigger: tr_111_eep_trd_mes_itio
-- Source:  eep_trd (入庫單)
-- Target:  mes_itio
-- Mapping: iono=trno, ioseq=LEFT(trseq,4), ioseqseq='TRD '
--          ioqty = +ABS(trqty) (入庫為正)
--          posino = wareno (來源無 posino)
-- =====================================================================
CREATE TRIGGER [dbo].[tr_011_eep_trd_mes_itio]
ON [dbo].[eep_trd]
AFTER  UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate wareno on INSERT/UPDATE
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        IF EXISTS (SELECT 1 FROM inserted WHERE wareno IS NULL OR RTRIM(wareno) = '')
        BEGIN
            RAISERROR(N'eep_trd: wareno 不可為空', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
    END

    -- DELETE old mes_itio rows
    DELETE io
    FROM mes_itio io
    INNER JOIN deleted d
        ON io.iono      = RTRIM(d.trno)
       AND io.ioseq     = LEFT(RTRIM(d.trseq), 4)
       AND io.ioseqseq  = 'TRD ';

    -- INSERT new mes_itio rows
    INSERT INTO mes_itio (iono, ioseq, ioseqseq, iodate, itemno, posino, wareno, plantno, compno, ioqty)
    SELECT
        RTRIM(i.trno),
        LEFT(RTRIM(i.trseq), 4),
        'TRD ',
        CONVERT(char(8), i.trdate, 112),
        RTRIM(i.itemno),
        RTRIM(i.wareno),                -- posino = wareno
        RTRIM(i.wareno),
        COALESCE(
            NULLIF(RTRIM(i.plantno), ''),
            RTRIM(w.plantno),
            RTRIM(i.wareno)
        ),
        COALESCE(
            NULLIF(RTRIM(p.compno), ''),
            N'公司代碼'
        ),
        ABS(ISNULL(i.trqty, 0))         -- 入庫 = 正數
    FROM inserted i
    LEFT JOIN eep_ware w
        ON RTRIM(i.wareno) = RTRIM(w.wareno)
    LEFT JOIN eep_plant p
        ON COALESCE(NULLIF(RTRIM(i.plantno),''), RTRIM(w.plantno)) = RTRIM(p.plantno);
END;
GO
