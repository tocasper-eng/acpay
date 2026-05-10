--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_98g_00_eep_purp]'))
   DROP TRIGGER [dbo].[tr_100_98g_00_eep_purp]
GO
create trigger tr_100_98g_00_eep_purp on eep_purp
after insert 
as
begin 

update eep_purp set menuflag='98G_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_purp.num = inserted.num 

end 


GO


