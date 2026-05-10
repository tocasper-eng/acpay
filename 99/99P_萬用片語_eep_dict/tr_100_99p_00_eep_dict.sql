--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_99p_00_eep_dict]'))
   DROP TRIGGER [dbo].[tr_100_99p_00_eep_dict]
GO
create trigger tr_100_99p_00_eep_dict on eep_dict
after insert 
as
begin 

update eep_dict set menuflag='99P_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_dict.num = inserted.num 

end 


GO


