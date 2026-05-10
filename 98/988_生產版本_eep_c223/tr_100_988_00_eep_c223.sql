--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_988_00_eep_c223]'))
   DROP TRIGGER [dbo].[tr_100_988_00_eep_c223]
GO
create trigger tr_100_988_00_eep_c223 on eep_c223
after insert 
as
begin 

update eep_c223  set menuflag='988_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_c223.num = inserted.num 

end 


GO


