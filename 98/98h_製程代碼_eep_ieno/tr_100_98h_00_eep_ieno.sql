--USE cfp 
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_98h_00_eep_ieno]'))
   DROP TRIGGER [dbo].[tr_100_98h_00_eep_ieno]
GO
create trigger tr_100_98h_00_eep_ieno on eep_ieno
after insert 
as
begin 

update eep_ieno set menuflag='98H_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_ieno.num = inserted.num 

end 


GO


