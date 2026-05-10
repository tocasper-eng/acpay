USE acpay 
GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_93i_10_eep_lined]'))
   DROP TRIGGER [dbo].[tr_100_93i_10_eep_lined]
GO
create trigger tr_100_93i_10_eep_lined on eep_lined
after insert 
as
begin 

update eep_lined set menuflag='93I_'+'10_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_lined.num = inserted.num 

end 


GO


