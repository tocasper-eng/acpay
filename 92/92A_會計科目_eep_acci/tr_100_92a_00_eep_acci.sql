--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_92a_00_eep_acci]'))
   DROP TRIGGER [dbo].[tr_100_92a_00_eep_acci]
GO
create trigger tr_100_92a_00_eep_acci on eep_acci
after insert 
as
begin 

update eep_acci set menuflag='92A_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_acci.num = inserted.num 

end 


GO
 
