--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_93g_00_eep_xdur]'))
   DROP TRIGGER tr_100_93g_00_eep_xdur
GO
create trigger tr_100_93g_00_eep_xdur on eep_xdur
after insert 
as
begin 

update eep_xdur set menuflag='93G_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_xdur.num = inserted.num 

end 


GO


