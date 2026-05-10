--use cfp
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_92k_00_eep_remano]'))
   DROP TRIGGER [dbo].[tr_100_92k_00_eep_remano]
GO
create trigger tr_100_92k_00_eep_remano on eep_remano
after insert 
as
begin 

update eep_remano  set menuflag='92K_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_remano.num = inserted.num 

end 


GO


