USE acpay 
GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'tr_100_a01_eep_iwd_20'))
   DROP TRIGGER [dbo].[tr_100_a01_eep_iwd_20]
GO
create trigger tr_100_a01_eep_iwd_20 on eep_iwd_20
after insert 
as
begin 

update eep_iwd_20 set menuflag='A01_'+'20_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_iwd_20.num = inserted.num 

end 


GO


