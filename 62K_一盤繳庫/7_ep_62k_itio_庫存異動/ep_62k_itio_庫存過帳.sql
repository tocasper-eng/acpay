--use acpay
 
go
--單據核准
if exists (select name from sysobjects where name = 'ep_62k_itio')
   drop procedure ep_62k_itio 
go
 
--exec .dbo.ep_62k_zy '62j_00_0000000000004','Y' 
create procedure ep_62k_itio
(
@menuflag char(20),
@chjerno  nvarchar(99) 
)
--casper--
as
begin

declare @trno char(10) 

select @trno = trno from eep_trh where menuflag = @menuflag 

 
MERGE INTO itio AS tgt
USING (
    SELECT
        trdate, trno, trseq, itemno, wareno, trqty, chjernoz
    FROM eep_trd
    WHERE trno = @trno
) AS src
    ON  tgt.iono     = src.trno
    AND tgt.ioseq    = src.trseq
 
 

-- 來源有、目標沒有,且 chjernoz 第一碼 = 'Y' → 新增
WHEN NOT MATCHED BY TARGET
     AND SUBSTRING(src.chjernoz, 1, 1) = 'Y'
THEN INSERT (
        iodate, iono, ioseq, ioseqseq, itemno,
        wareno, posino, alocno, wareswt, qty
     )
     VALUES (
        src.trdate, src.trno, src.trseq, 'O', src.itemno,
        src.wareno, src.wareno, src.wareno, src.wareno, src.trqty
     )

-- 兩邊都有,且 chjernoz 第一碼 = 'Y' → 更新(保持同步)
WHEN MATCHED
     AND SUBSTRING(src.chjernoz, 1, 1) = 'Y'
THEN UPDATE SET
        tgt.iodate  = src.trdate,
        tgt.wareno  = src.wareno,
        tgt.posino  = src.wareno,
        tgt.alocno  = src.wareno,
        tgt.wareswt = src.wareno,
        tgt.qty   = src.trqty

-- 兩邊都有,但 chjernoz 第一碼 != 'Y' → 刪除
WHEN MATCHED
     AND SUBSTRING(src.chjernoz, 1, 1) <> 'Y'
THEN DELETE
;

end 
go 

