USE acpay 

GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_c01_00_eep_pos]'))
   DROP TRIGGER [dbo].[tr_100_c01_00_eep_pos]
GO
create trigger tr_100_c01_00_eep_pos on eep_pos 
after insert 
as
begin 

update eep_pos set menuflag='C01_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_pos.num = inserted.num 

end 


GO


