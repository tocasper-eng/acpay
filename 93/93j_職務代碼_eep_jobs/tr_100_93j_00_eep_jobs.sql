--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_93j_00_eep_jobs]'))
   DROP TRIGGER tr_100_93j_00_eep_jobs
GO
create trigger tr_100_93j_00_eep_jobs on eep_jobs
after insert 
as
begin 

update eep_jobs set menuflag='93J_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_jobs.num = inserted.num 

end 


GO


