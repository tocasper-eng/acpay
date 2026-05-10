--use cfp 
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_989_00_eep_co2e]'))
   DROP TRIGGER [dbo].[tr_100_989_00_eep_co2e]
GO
create trigger tr_100_989_00_eep_co2e on eep_co2e
after insert 
as
begin 

update eep_co2e set menuflag='989_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_co2e.num = inserted.num 

end 


GO


