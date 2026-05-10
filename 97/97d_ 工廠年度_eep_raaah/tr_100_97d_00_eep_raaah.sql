--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_97d_00_eep_raaah]'))
   DROP TRIGGER [dbo].[tr_100_97d_00_eep_raaah]
GO
create trigger tr_100_97d_00_eep_raaah on eep_raaah 
after insert 
as
begin 

update eep_raaah set menuflag='97D_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_raaah.num = inserted.num 

end 


GO


