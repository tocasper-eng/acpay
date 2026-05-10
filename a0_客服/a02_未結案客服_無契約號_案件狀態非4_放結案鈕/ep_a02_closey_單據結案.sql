use acpay
go
--單據結案
if exists (select name from sysobjects where name = 'ep_a02_closey')
   drop procedure ep_a02_closey 
go
--exec chjer.dbo.ep_a02_closey  980 
create procedure ep_a02_closey
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
from eep_a02 where menuflag = @menuflag 

if substring(isnull(@chjernoc,'') ,1,1) <> 'Y' return

if substring(isnull(@chjernoz,'') ,1,1) <> 'Y' return 

update eep_a02 set chjernoc = @chjernoc 

where menuflag = @menuflag 

insert into eep_logs(dt,menuflag,chjernoc) 
values ( GETDATE() , @menuflag,@chjernoc ) 
 

end 
GO

