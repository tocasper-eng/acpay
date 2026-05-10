--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_91j_00_eep_num8]'))
   DROP TRIGGER [dbo].[tr_100_91j_00_eep_num8]
GO
create trigger tr_100_91j_00_eep_num8 on eep_num8
after insert 
as
begin 

update eep_num8 set menuflag='91J_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_num8.num = inserted.num 

end 


GO


