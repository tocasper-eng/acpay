--use cfp
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_92h_00_eep_accs]'))
   DROP TRIGGER [dbo].[tr_100_92h_00_eep_accs]
GO
create trigger tr_100_92h_00_eep_accs  on eep_accs
after insert 
as
begin 

update eep_accs set menuflag='92H_'+'01_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_accs.num = inserted.num

end 


GO


