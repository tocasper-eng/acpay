--use cfp 
--go 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_98b_00_eep_mrpc]'))
   DROP TRIGGER [dbo].[tr_100_98b_00_eep_mrpc]
GO
create trigger tr_100_98b_00_eep_mrpc on eep_mrpc
after insert 
as
begin 

update eep_mrpc set menuflag='98B_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_mrpc.num = inserted.num 

end 


GO


