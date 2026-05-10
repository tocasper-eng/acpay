USE acpay 
GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_a01_10_eep_iwd]'))
   DROP TRIGGER [dbo].[tr_100_a01_10_eep_iwd]
GO
create trigger tr_100_a01_10_eep_iwd on eep_iwd
after insert 
as
begin 

update eep_iwd set menuflag='A01_'+'10_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_iwd.num = inserted.num 

end 


GO


