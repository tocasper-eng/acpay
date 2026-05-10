--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_98n_00_eep_rtd]'))
   DROP TRIGGER [dbo].[tr_100_98n_00_eep_rtd]
GO
create trigger tr_100_98n_00_eep_rtd on eep_rtd
after insert 
as
begin 

update eep_rtd set menuflag='98N_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_rtd.num = inserted.num 

end 


GO


