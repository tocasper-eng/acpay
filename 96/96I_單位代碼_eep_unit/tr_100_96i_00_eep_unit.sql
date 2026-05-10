--use cfp
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_96i_00_eep_unit]'))
   DROP TRIGGER [dbo].[tr_100_96i_00_eep_unit]
GO
create trigger tr_100_96i_00_eep_unit on eep_unit
after insert 
as
begin 

update eep_unit set menuflag='96I_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_unit.num = inserted.num 

end 


GO


