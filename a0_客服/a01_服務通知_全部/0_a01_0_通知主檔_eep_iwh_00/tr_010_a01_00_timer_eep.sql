USE acpay 
GO
 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_010_a01_00_timer_eep]'))
   DROP TRIGGER [dbo].[tr_010_a01_00_timer_eep]
GO
create trigger tr_010_a01_00_timer_eep  on eep_iwh 
after update 
as
begin 


declare @祇布狝叭ùら	 datetime --AP
declare @纔る计	     INT     --AQ
declare @筿祇布    	 nvarCHAR(10) 
declare @menuflag        nvarCHAR(100) 
declare @絪腹        nvarchar(100) 

select top 1 @絪腹 =絪腹, @menuflag = menuflag  from inserted 


select top 1 
@祇布狝叭ùら=祇布狝叭ùら,--AP
@纔る计	 =纔る计	   --AQ
from  pos  
where 絪腹 = @絪腹 

if @祇布狝叭ùら is null  and isnull(@纔る计,0)=0 
   set @筿祇布    = 'ゼㄏノ'
else 
   if isnull(@纔る计,0)<>0 and @祇布狝叭ùら is null  
      set @筿祇布    = '币ノ'
   else 
      if isnull(@纔る计,0)<>0 and @祇布狝叭ùら is not null  
         set @筿祇布    = 'ㄏノ'
      else 
         set @筿祇布    = 'unknow'
 
    
update eep_iwh set    筿祇布    = @筿祇布
where menuflag = @menuflag and isnull(筿祇布,'') <> isnull(@筿祇布,'')

MERGE dbo.timer_eep AS T
USING inserted AS S
    ON T.menuflag = S.menuflag
WHEN MATCHED THEN
    UPDATE SET T.ok = 'N'
WHEN NOT MATCHED THEN
    INSERT (menuflag, chjernoi, ok)
    VALUES (S.menuflag,S.chjernoi,'N');


end 


GO


