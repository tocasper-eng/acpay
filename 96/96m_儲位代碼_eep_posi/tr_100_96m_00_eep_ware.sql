--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_96m_00_eep_posi]'))
   DROP TRIGGER [dbo].[tr_100_96m_00_eep_posi]
GO
create trigger tr_100_96m_00_eep_posi on eep_posi
after insert 
as
begin 

update eep_posi set menuflag='96M_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_posi.num = inserted.num 

end 


GO


