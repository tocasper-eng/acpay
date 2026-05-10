--use cfp 
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_94m_00_eep_rect]'))
   DROP TRIGGER [dbo].[tr_100_94m_00_eep_rect]
GO
create trigger tr_100_94m_00_eep_rect on eep_rect
after insert 
as
begin 

update eep_rect set menuflag='94M_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_rect.num = inserted.num 

end 


GO


