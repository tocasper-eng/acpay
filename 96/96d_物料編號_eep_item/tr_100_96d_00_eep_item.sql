--use cfp 
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_96d_00_eep_item]'))
   DROP TRIGGER [dbo].[tr_100_96d_00_eep_item]
GO
create trigger tr_100_96d_00_eep_item on eep_item
after insert 
as
begin 

update eep_item set menuflag='96D_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_item.num = inserted.num 

end 


GO


