USE acpay 
GO
DROP FUNCTION [dbo].[uf_menutable_caption]
GO

create function [dbo].[uf_menutable_caption] 
(
@menuid   nvarchar(30) 

)
returns nvarchar(99) 
--casper--06UNF\C
-- print .dbo.uf_menutable_caption('0')  
 
as
begin
declare @caption nvarchar(50) 
SELECT @caption = caption 
from MENUTABLE
where menuid = @menuid 
return ( @caption+ '-' + @menuid  )
end


GO


