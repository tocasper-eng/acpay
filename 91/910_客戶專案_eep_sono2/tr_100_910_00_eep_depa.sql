--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_910_00_eep_sono2]'))
   DROP TRIGGER [dbo].[tr_100_910_00_eep_sono2]
GO
create trigger tr_100_910_00_eep_sono2 on eep_sono2 
after insert 
as
begin 

update eep_sono2  set menuflag='910_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_sono2.num = inserted.num 

end 


GO


