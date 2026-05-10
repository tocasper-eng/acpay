--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_97e_00_eep_raaa]'))
   DROP TRIGGER [dbo].[tr_100_97e_00_eep_raaa]
GO
create trigger tr_100_97a_00_eep_raaa on eep_raaa
after insert 
as
begin 

update eep_raaa set menuflag='97E_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_raaa.num = inserted.num 

end 


GO


