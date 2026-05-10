USE acpay 
GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_93a_10_eep_adde]'))
   DROP TRIGGER [dbo].[tr_100_93a_10_eep_adde]
GO
create trigger tr_100_93a_10_eep_adde on eep_adde
after insert 
as
begin 

update eep_adde set menuflag='93A_'+'10_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_adde.num = inserted.num 

end 


GO


