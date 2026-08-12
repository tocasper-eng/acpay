use acpay
go 
SELECT DISTINCT d.trno
FROM dbo.eep_trd d
LEFT JOIN dbo.eep_trh h ON h.trno = d.trno
WHERE h.trno IS NULL;
go 
ALTER TABLE dbo.eep_trd DROP CONSTRAINT IF EXISTS FK_trd_trh;
go 
ALTER TABLE dbo.eep_trd WITH NOCHECK
    ADD CONSTRAINT FK_trd_trh FOREIGN KEY (trno) REFERENCES dbo.eep_trh (trno);