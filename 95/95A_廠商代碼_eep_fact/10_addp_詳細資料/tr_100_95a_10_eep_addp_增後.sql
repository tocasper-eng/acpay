USE acpay 
GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_95a_10_eep_addp]'))
   DROP TRIGGER [dbo].[tr_100_95a_10_eep_addp]
GO
create trigger tr_100_95a_10_eep_addp on eep_addp
after insert 
as
begin 

update eep_addp set menuflag='95A_'+'10_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_addp.num = inserted.num 

end 


GO


