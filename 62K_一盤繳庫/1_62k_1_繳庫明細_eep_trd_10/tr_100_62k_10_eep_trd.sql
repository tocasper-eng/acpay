USE acpay 

GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_62k_10_eep_trd]'))
   DROP TRIGGER [dbo].[tr_100_62k_10_eep_trd]
GO
create trigger tr_100_62k_10_eep_trd on eep_trd 
after insert 
as
begin 

update eep_trd set menuflag='62K_'+'10_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_trd.num = inserted.num 

end 


GO


