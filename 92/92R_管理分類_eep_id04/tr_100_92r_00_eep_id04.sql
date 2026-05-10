--use cfp
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_92r_00_eep_id04]'))
   DROP TRIGGER [dbo].[tr_100_92r_00_eep_id04]
GO
create trigger tr_100_92r_00_eep_id04 on eep_id04
after insert 
as
begin 

update eep_id04  set menuflag='92R_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_id04.num = inserted.num 

end 


GO


