use cfp
go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_98m_00_eep_rth]'))
   DROP TRIGGER [dbo].[tr_100_98m_00_eep_rth]
GO
create trigger tr_100_98m_00_eep_rth on eep_mach
after insert 
as
begin 

update eep_rth set menuflag='98H_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_rth.num = inserted.num 

end 


GO


