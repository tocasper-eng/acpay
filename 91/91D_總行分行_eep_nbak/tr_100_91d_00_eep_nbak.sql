--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_91d_00_eep_nbak]'))
   DROP TRIGGER [dbo].[tr_100_91d_00_eep_nbak]
GO
create trigger tr_100_91d_00_eep_nbak on eep_nbak
after insert 
as
begin 

update eep_nbak set menuflag='91D_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_nbak.num = inserted.num 

end 


GO


