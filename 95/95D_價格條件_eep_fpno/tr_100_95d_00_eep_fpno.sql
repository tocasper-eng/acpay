--use cfp 
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_95d_00_eep_fpno]'))
   DROP TRIGGER [dbo].[tr_100_95d_00_eep_fpno]
GO
create trigger tr_100_95d_00_eep_fpno on eep_fpno
after insert 
as 
begin 
update eep_fpno set menuflag='95D_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_fpno.num = inserted.num 

end 


GO


