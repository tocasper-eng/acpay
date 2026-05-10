USE acpay 
GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_99g_10_eep_addc]'))
   DROP TRIGGER [dbo].[tr_100_99g_10_eep_addc]
GO
create trigger tr_100_99g_10_eep_addc on eep_addc
after insert 
as
begin 

update eep_addc set menuflag='99G_'+'10_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_addc.num = inserted.num 

end 


GO


