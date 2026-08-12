--use cfp
--go
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_91a_00_eep_depa]'))
   DROP TRIGGER [dbo].[tr_100_91a_00_eep_depa]
GO
create trigger tr_100_91a_00_eep_depa on eep_depa
after insert 
as
begin 

update eep_depa set menuflag='91A_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_depa.num = inserted.num 

end 


GO


