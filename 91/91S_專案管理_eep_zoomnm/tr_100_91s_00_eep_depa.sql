--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_91s_00_eep_zoomnm]'))
   DROP TRIGGER [dbo].[tr_100_91s_00_eep_zoomnm]
GO
create trigger tr_100_91s_00_eep_zoomnm on eep_zoomnm 
after insert 
as
begin 

update eep_zoomnm  set menuflag='91S_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_zoomnm.num = inserted.num 

end 


GO


