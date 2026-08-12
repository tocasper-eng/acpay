use acpay
go 
SELECT DISTINCT d.tdno
FROM dbo.eep_tdd d
LEFT JOIN dbo.eep_tdh h ON h.tdno = d.tdno
WHERE h.tdno IS NULL;
go 
ALTER TABLE dbo.eep_tdd DROP CONSTRAINT IF EXISTS FK_tdd_tdh;
go 
ALTER TABLE dbo.eep_tdd WITH NOCHECK
    ADD CONSTRAINT FK_tdd_tdh FOREIGN KEY (tdno) REFERENCES dbo.eep_tdh (tdno);