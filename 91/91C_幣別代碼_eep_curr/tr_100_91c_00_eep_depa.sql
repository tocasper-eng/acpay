--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_91c_00_eep_curr]'))
   DROP TRIGGER [dbo].[tr_100_91c_00_eep_curr]
GO
create trigger tr_100_91c_00_eep_curr on eep_curr
after insert 
as
begin 

update eep_curr set menuflag='91C_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_curr.num = inserted.num 

end 


GO


