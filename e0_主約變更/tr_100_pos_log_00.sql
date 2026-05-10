USE acpay 
GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_pos_log]'))
   DROP TRIGGER [dbo].[tr_100_pos_log]
GO
create trigger tr_100_pos_log on pos_log
after insert 
as
begin 

update pos_log set menuflag='POS_log_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where pos_log.num = inserted.num 

end 


GO


