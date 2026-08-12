--USE [chjer]
--GO

IF EXISTS (SELECT name FROM sysobjects WHERE name = 'up_stka_itea_net_set' AND type = 'P')
    DROP PROCEDURE up_stka_itea_net_set
GO

CREATE PROCEDURE up_stka_itea_net_set
(
    @num    bigint,
    @userid char(08)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @cldate char(08);
    SELECT TOP 1 @cldate = cldate FROM stka_clitea WHERE num = @num;

    BEGIN TRY
        BEGIN TRAN;

        -- 步驟 1:找出這批「未處理異動」涉及的 key,以及每個 key 最早的異動日
        --         這就是每個 key 需要往後重算的起點
        ;WITH changed AS
        (
            SELECT
                itemno, wareno, posino,
                ISNULL(wareswt, '') AS wareswt,
                ISNULL(alocno,  '') AS alocno,
                MIN(iodate)         AS min_iodate
            FROM itio
            WHERE iodate >= @cldate
              AND ISNULL(tmp, '') <> 'Y'
            GROUP BY
                itemno, wareno, posino,
                ISNULL(wareswt, ''), ISNULL(alocno, '')
        ),
        -- 步驟 2:每個 key 在「最早異動日之前」的既有累計值,當作起跑基準
        base AS
        (
            SELECT
                c.itemno, c.wareno, c.posino, c.wareswt, c.alocno,
                c.min_iodate,
                ISNULL((
                    SELECT TOP 1 s.balance
                    FROM stka_itea s WITH (NOLOCK)
                    WHERE s.itemno  = c.itemno
                      AND s.wareno  = c.wareno
                      AND s.posino  = c.posino
                      AND s.wareswt = c.wareswt
                      AND s.alocno  = c.alocno
                      AND s.iodate  < c.min_iodate
                    ORDER BY s.iodate DESC
                ), 0) AS base_balance
            FROM changed c
        ),
        -- 步驟 3:抓出受影響 key、從最早異動日起的每日異動量(彙總)
        daily AS
        (
            SELECT
                i.iodate,
                i.itemno, i.wareno, i.posino,
                ISNULL(i.wareswt, '') AS wareswt,
                ISNULL(i.alocno,  '') AS alocno,
                SUM(ISNULL(i.qty, 0)) AS daily_qty,
                b.base_balance
            FROM itio i
            INNER JOIN base b
                ON  b.itemno  = i.itemno
                AND b.wareno  = i.wareno
                AND b.posino  = i.posino
                AND b.wareswt = ISNULL(i.wareswt, '')
                AND b.alocno  = ISNULL(i.alocno, '')
                AND i.iodate  >= b.min_iodate
            GROUP BY
                i.iodate, i.itemno, i.wareno, i.posino,
                ISNULL(i.wareswt, ''), ISNULL(i.alocno, ''),
                b.base_balance
        ),
        -- 步驟 4:從基準值起,往後累加
        recalc AS
        (
            SELECT
                iodate, itemno, wareno, posino, wareswt, alocno,
                base_balance
                + SUM(daily_qty) OVER (
                    PARTITION BY itemno, wareno, posino, wareswt, alocno
                    ORDER BY iodate
                    ROWS UNBOUNDED PRECEDING
                  ) AS balance
            FROM daily
        )
        -- 步驟 5:用 MERGE 把重算結果寫回 stka_itea(有則更新、無則新增)
        MERGE INTO stka_itea AS tgt
        USING recalc AS src
            ON  tgt.iodate  = src.iodate
            AND tgt.itemno  = src.itemno
            AND tgt.wareno  = src.wareno
            AND tgt.posino  = src.posino
            AND tgt.wareswt = src.wareswt
            AND tgt.alocno  = src.alocno
        WHEN MATCHED AND tgt.balance <> src.balance THEN
            UPDATE SET tgt.balance = src.balance
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (iodate, itemno, wareno, posino, wareswt, alocno, balance)
            VALUES (src.iodate, src.itemno, src.wareno, src.posino,
                    src.wareswt, src.alocno, src.balance);

        -- 步驟 6:標記已處理
        UPDATE i
        SET i.tmp = 'Y'
        FROM itio i
        WHERE i.iodate >= @cldate
          AND ISNULL(i.tmp, '') <> 'Y';

        -- 步驟 7:更新處理註記
        UPDATE stka_clitea
        SET chjernou = chjer.dbo.uf_chjernoi(GETDATE(), @userid)
        WHERE num = @num;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        THROW;
    END CATCH
END
GO