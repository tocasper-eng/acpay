--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_93a_00_eep_empl]'))
   DROP TRIGGER tr_100_93a_00_eep_empl
GO
create trigger tr_100_93a_00_eep_empl on eep_empl
after insert 
as
begin 

update eep_empl set menuflag='93A_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_empl.num = inserted.num 

end 


GO


