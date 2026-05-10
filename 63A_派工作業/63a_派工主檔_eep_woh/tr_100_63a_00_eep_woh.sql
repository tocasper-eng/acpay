USE acpay 

GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_a01_00_eep_iwh]'))
   DROP TRIGGER [dbo].[tr_100_a01_00_eep_iwh]
GO
create trigger tr_100_a01_00_eep_iwh on eep_iwh 
after insert 
as
begin 

update eep_iwh set menuflag='A01_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_iwh.num = inserted.num 

end 


GO


