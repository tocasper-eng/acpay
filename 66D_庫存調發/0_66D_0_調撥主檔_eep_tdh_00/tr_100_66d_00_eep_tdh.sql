USE acpay 

GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_66d_00_eep_tdh]'))
   DROP TRIGGER [dbo].[tr_100_66d_00_eep_tdh]
GO
create trigger tr_100_66d_00_eep_tdh on eep_tdh 
after insert 
as
begin 

update eep_tdh set menuflag='66D_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_tdh.num = inserted.num 

end 


GO


