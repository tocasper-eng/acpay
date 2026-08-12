USE acpay 

GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_62j_00_eep_toh]'))
   DROP TRIGGER [dbo].[tr_100_62j_00_eep_toh]
GO
create trigger tr_100_62j_00_eep_toh on eep_toh 
after insert 
as
begin 

update eep_toh set menuflag='62J_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_toh.num = inserted.num 

end 


GO


