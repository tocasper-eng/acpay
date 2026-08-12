USE acpay 

GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_62j_10_eep_tod]'))
   DROP TRIGGER [dbo].[tr_100_62j_10_eep_tod]
GO
create trigger tr_100_62j_10_eep_tod on eep_tod 
after insert 
as
begin 

update eep_tod set menuflag='62J_'+'10_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_tod.num = inserted.num 

end 


GO


