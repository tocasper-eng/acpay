--use cfp 
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_94k_00_eep_sdorg]'))
   DROP TRIGGER [dbo].[tr_100_94k_00_eep_sdorg]
GO
create trigger tr_100_94k_00_eep_sdorg on eep_sdorg
after insert 
as
begin 

update eep_sdorg set menuflag='94K_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_sdorg.num = inserted.num 

end 


GO


