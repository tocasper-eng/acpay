USE acpay 
GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_96d_10_eep_addi]'))
   DROP TRIGGER [dbo].[tr_100_96d_10_eep_addi]
GO
create trigger tr_100_96d_10_eep_addi on eep_addi
after insert 
as
begin 

update eep_addi set menuflag='96D_'+'10_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_addi.num = inserted.num 

end 


GO


