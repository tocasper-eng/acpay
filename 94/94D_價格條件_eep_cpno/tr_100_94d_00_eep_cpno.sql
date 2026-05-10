--use cfp 
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_94d_00_eep_cpno]'))
   DROP TRIGGER [dbo].[tr_100_94d_00_eep_cpno]
GO
create trigger tr_100_94d_00_eep_cpno on eep_cpno
after insert 
as
begin 
update eep_cpno set menuflag='94D_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_cpno.num = inserted.num 

end 


GO


