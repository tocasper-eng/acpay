--use cfp
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_92l_00_eep_remanm]'))
   DROP TRIGGER [dbo].[tr_100_92l_00_eep_remanm]
GO
create trigger tr_100_92l_00_eep_remanm on eep_remanm
after insert 
as
begin 

update eep_remanm  set menuflag='92L_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_remanm.num = inserted.num 

end 


GO


