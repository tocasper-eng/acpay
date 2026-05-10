use acpay 
GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_010_95a_10_timer_eep]'))
   DROP TRIGGER [dbo].[tr_010_95a_10_timer_eep]
GO
create trigger tr_010_95a_10_timer_eep  on eep_addp 
after update 
as
begin 


 
MERGE dbo.timer_eep AS T
USING inserted AS S
    ON T.menuflag = S.menuflag
WHEN MATCHED THEN
    UPDATE SET T.ok = 'N'
WHEN NOT MATCHED THEN
    INSERT (menuflag, chjernoi, ok)
    VALUES (S.menuflag,S.chjernoi, 'N');



end 


GO


