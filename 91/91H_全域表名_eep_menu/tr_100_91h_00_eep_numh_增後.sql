--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_91h_00_eep_menu]'))
   DROP TRIGGER [dbo].[tr_100_91h_00_eep_menu]
GO
create trigger tr_100_91h_00_eep_menu on eep_menu
after insert 
as
begin 

update eep_menu set menuflag='91H_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_menu.num = inserted.num 

end 


GO


