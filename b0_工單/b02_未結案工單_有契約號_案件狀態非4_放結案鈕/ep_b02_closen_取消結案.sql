use acpay
go
go
--單據核准
if exists (select name from sysobjects where name = 'ep_a01_closen')
   drop procedure ep_a01_closen 
go
--exec chjer.dbo.ep_a01_closen  980 
create procedure ep_a01_closen
(
@menuflag char(20) 
)
--casper--
as
begin


declare @chjernoc nvarchar(99) 
declare @chjernoz nvarchar(99)

select  @chjernoc = chjernoc,  
        @chjernoz = chjernoz 
from eep_iwh where menuflag = @menuflag 

if substring(isnull(@chjernoc,'') ,1,1) <> 'Y' return

--前端已檔，不必寫入主檔
if substring(isnull(@chjernoz,'') ,1,1) <> 'Y' return 

--同步更新子檔
update eep_iwd set chjernoc = @chjernoc

where menuflag = @menuflag 

 

end 
GO

