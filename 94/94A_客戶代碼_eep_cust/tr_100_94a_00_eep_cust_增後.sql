--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_94a_00_eep_cust]'))
   DROP TRIGGER [dbo].[tr_100_94a_00_eep_cust]
GO
create trigger tr_100_94a_00_eep_cust on eep_cust
after insert 
as
begin 

update eep_cust set menuflag='94A_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_cust.num = inserted.num 

end 


GO


