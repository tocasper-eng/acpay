--use cfp
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_92j_00_eep_codenm]'))
   DROP TRIGGER [dbo].[tr_100_92j_00_eep_codenm]
GO
create trigger tr_100_92j_00_eep_codenm on eep_codenm
after insert 
as
begin 

update eep_codenm  set menuflag='92J_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_codenm.num = inserted.num 

end 


GO


