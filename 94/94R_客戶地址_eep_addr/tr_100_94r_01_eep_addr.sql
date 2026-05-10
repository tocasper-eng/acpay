--use cfp 
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_94r_00_eep_addr]'))
   DROP TRIGGER [dbo].[tr_100_94r_00_eep_addr]
GO
create trigger tr_100_94r_00_eep_addr  on eep_addr
after insert 
as
begin 

update eep_addr set menuflag='94R_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_addr.num = inserted.num  

end 


GO


