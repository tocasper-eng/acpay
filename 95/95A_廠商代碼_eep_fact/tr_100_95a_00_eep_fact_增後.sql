--USE cfp 
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_95a_00_eep_fact]'))
   DROP TRIGGER [dbo].[tr_100_95a_00_eep_fact]
GO
create trigger tr_100_95a_00_eep_fact on eep_fact
after insert 
as
begin 

update eep_fact set menuflag='95A_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_fact.num = inserted.num 

end 


GO


