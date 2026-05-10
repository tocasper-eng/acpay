--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_99g_00_eep_comp]'))
   DROP TRIGGER [dbo].[tr_100_99g_00_eep_comp]
GO
create trigger tr_100_99g_00_eep_comp on eep_comp
after insert 
as
begin 

update eep_comp set menuflag='99G_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_comp.num = inserted.num 

end 


GO


