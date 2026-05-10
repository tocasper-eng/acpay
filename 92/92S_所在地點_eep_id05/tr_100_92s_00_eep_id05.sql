--use cfp
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_92s_00_eep_id05]'))
   DROP TRIGGER [dbo].[tr_100_92s_00_eep_id05]
GO
create trigger tr_100_92s_00_eep_id05 on eep_id05 
after insert 
as
begin 

update eep_id05  set menuflag='92S_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_id05.num = inserted.num 

end 


GO


