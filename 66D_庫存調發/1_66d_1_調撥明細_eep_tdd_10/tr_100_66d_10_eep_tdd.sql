USE acpay 

GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_66d_10_eep_tdd]'))
   DROP TRIGGER [dbo].[tr_100_66d_10_eep_tdd]
GO
create trigger tr_100_66d_10_eep_tdd on eep_tdd 
after insert 
as
begin 

update eep_tdd set menuflag='66D_'+'10_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_tdd.num = inserted.num 

end 


GO


