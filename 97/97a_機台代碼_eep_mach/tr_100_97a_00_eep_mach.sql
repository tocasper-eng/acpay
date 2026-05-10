--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_97a_00_eep_mach]'))
   DROP TRIGGER [dbo].[tr_100_97a_00_eep_mach]
GO
create trigger tr_100_97a_00_eep_mach on eep_mach
after insert 
as
begin 

update eep_mach set menuflag='97A_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_mach.num = inserted.num 

end 


GO


