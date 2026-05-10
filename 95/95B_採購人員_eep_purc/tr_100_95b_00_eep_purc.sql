--use cfp 
--go 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_95b_00_eep_purc]'))
   DROP TRIGGER [dbo].[tr_100_95b_00_eep_purc]
GO
create trigger tr_100_95b_00_eep_purc on eep_purc
after insert 
as
begin 

update eep_purc set menuflag='95B_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_purc.num = inserted.num 

end 


GO


