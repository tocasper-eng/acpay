USE acpay 
GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_a01_eep_iwd_10]'))
   DROP TRIGGER [dbo].[tr_100_a01_eep_iwd_10]
GO
create trigger tr_100_a01_eep_iwd_10 on eep_iwd_10
after insert 
as
begin 

update eep_iwd_10 set menuflag='A01_'+'10_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_iwd_10.num = inserted.num 

end 


GO


