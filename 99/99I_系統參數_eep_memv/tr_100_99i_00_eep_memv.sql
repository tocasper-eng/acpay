ALTER TRIGGER tr_100_99i_00_eep_memv ON eep_memv
AFTER INSERT 
AS
BEGIN
    -- 關鍵：檢查是否為 Trigger 引起的更新，避免死迴圈
    IF (ROWCOUNT_BIG() = 0 OR TRIGGER_NESTLEVEL() > 1) RETURN;

    -- 使用 UPDATE FROM 方式批次更新
    UPDATE t
    SET t.menuflag = '99I_' + '00_' + dbo.uf_strzero(i.num, 13)
    FROM eep_memv t
    INNER JOIN inserted i ON t.num = i.num;
END