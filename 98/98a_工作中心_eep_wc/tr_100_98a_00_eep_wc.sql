--USE cfp 
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_98a_00_eep_wc]'))
   DROP TRIGGER [dbo].[tr_100_98a_00_eep_wc]
GO
create trigger tr_100_98a_00_eep_wc on eep_wc
after insert 
as
begin 

update eep_wc set menuflag='98A_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_wc.num = inserted.num 

end 


GO


