use acpay
go 
SELECT DISTINCT d.tono
FROM dbo.eep_Tod d
LEFT JOIN dbo.eep_toh h ON h.tono = d.tono
WHERE h.tono IS NULL;
go 
ALTER TABLE dbo.eep_Tod DROP CONSTRAINT IF EXISTS FK_Tod_toh;
go 
ALTER TABLE dbo.eep_Tod WITH NOCHECK
    ADD CONSTRAINT FK_Tod_toh FOREIGN KEY (tono) REFERENCES dbo.eep_toh (tono);