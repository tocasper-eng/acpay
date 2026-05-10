--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_91i_00_eep_numh]'))
   DROP TRIGGER [dbo].[tr_100_91i_00_eep_numh]
GO
create trigger tr_100_91i_00_eep_numh on eep_numh
after insert 
as
begin 

update eep_numh set menuflag='91I_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_numh.num = inserted.num 

end 


GO


