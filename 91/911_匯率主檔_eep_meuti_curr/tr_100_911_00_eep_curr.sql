--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_911_00_eep_muti_curr]'))
   DROP TRIGGER [dbo].[tr_100_911_00_eep_muti_curr]
GO
create trigger tr_100_911_00_eep_muti_curr on eep_muti_curr
after insert 
as
begin 

update eep_muti_curr set menuflag='911_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_muti_curr.num = inserted.num 

end 


GO


