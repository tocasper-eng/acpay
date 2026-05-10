use cfp 
go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_94g_00_eep_area]'))
   DROP TRIGGER [dbo].[tr_100_94g_00_eep_area]
GO
create trigger tr_100_94g_00_eep_area on eep_area
after insert 
as
begin 

update eep_area set menuflag='94G_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_area.num = inserted.num 

end 


GO


