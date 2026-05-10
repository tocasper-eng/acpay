--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_98i_00_eep_clas]'))
   DROP TRIGGER [dbo].[tr_100_98i_00_eep_clas]
GO
create trigger tr_100_98i_00_eep_clas on eep_clas
after insert 
as
begin 

update eep_clas set menuflag='98I_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_clas.num = inserted.num 

end 


GO


