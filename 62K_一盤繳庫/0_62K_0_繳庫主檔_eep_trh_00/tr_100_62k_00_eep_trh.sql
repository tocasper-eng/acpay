USE acpay 

GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_62k_00_eep_trh]'))
   DROP TRIGGER [dbo].[tr_100_62k_00_eep_trh]
GO
create trigger tr_100_62k_00_eep_trh on eep_trh 
after insert 
as
begin 

update eep_trh set menuflag='62K_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_trh.num = inserted.num 

end 


GO


