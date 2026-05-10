--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_912_00_eep_muti_exra]'))
   DROP TRIGGER [dbo].[tr_100_912_00_eep_muti_exra]
GO
create trigger tr_100_912_00_eep_muti_exra  on eep_muti_exra
after insert 
as
begin 

update eep_muti_exra set menuflag='912_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_muti_exra.num = inserted.num

end 


GO


