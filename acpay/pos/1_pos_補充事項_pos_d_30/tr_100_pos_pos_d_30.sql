USE acpay 
GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_pos_d_30]'))
   DROP TRIGGER [dbo].[tr_100_pos_d_30]
GO
create trigger tr_100_pos_d_30 on pos_d_30
after insert 
as
begin 

update pos_d_30 set menuflag='POS_'+'30_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where pos_d_30.num = inserted.num 

end 


GO


