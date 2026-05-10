--use cfp
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_92q_00_eep_id01]'))
   DROP TRIGGER [dbo].[tr_100_92q_00_eep_id01]
GO
create trigger tr_100_92q_00_eep_id01 on eep_id01
after insert 
as
begin 

update eep_id01  set menuflag='92Q_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_id01.num = inserted.num 

end 


GO


