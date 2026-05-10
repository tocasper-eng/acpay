--use cfp 
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_95k_00_eep_puorg]'))
   DROP TRIGGER [dbo].[tr_100_95k_00_eep_puorg]
GO
create trigger tr_100_95k_00_eep_puorg on eep_puorg
after insert 
as
begin 

update eep_puorg set menuflag='95K_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_puorg.num = inserted.num 

end 


GO


