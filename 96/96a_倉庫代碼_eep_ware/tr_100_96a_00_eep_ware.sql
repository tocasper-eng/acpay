--use cfp
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_96a_00_eep_ware]'))
   DROP TRIGGER [dbo].[tr_100_96a_00_eep_ware]
GO
create trigger tr_100_96a_00_eep_ware on eep_ware
after insert 
as
begin 

update eep_ware set menuflag='96A_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_ware.num = inserted.num 

end 


GO


