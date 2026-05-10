--use cfp 
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_95m_00_eep_payt]'))
   DROP TRIGGER [dbo].[tr_100_95m_00_eep_payt]
GO
create trigger tr_100_95m_00_eep_payt on eep_payt
after insert 
as
begin 

update eep_payt set menuflag='95M_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_payt.num = inserted.num 

end 


GO


