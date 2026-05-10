use acpay
go
--單據結案
if exists (select name from sysobjects where name = 'ep_a01_closey')
   drop procedure ep_a01_closey 
go
--exec .dbo.ep_a01_closey 'A01_00_0000000000014','dddd' 
--select chjernoc,chjernoz,menuflag, * from eep_iwh where menuflag= 'A01_00_0000000000014'

create procedure ep_a01_closey
(
@menuflag char(20) ,
@chjerno  nvarchar(99) 
)
--casper--
as
begin

 
declare @chjernoz nvarchar(99)
declare @chjernoc nvarchar(99)

select  @chjernoc = chjernoc , 
        @chjernoz = chjernoz 
from eep_iwh where menuflag = @menuflag 
 

--未核准，不必執行
if substring(isnull(@chjernoz,'') ,1,1) <> 'Y' return 
--已結案，不必執行
 
if substring(isnull(@chjernoc,'') ,1,1) =  'Y' return 

 

--新的結案資訊
set @chjernoc = 'Y::' + isnull(@chjerno,'') 

 

update eep_iwh  set chjernoc = @chjernoc 

where menuflag = @menuflag 

insert into eep_logs(dt,menuflag,chjernoc) 
values ( GETDATE() , @menuflag,@chjernoc ) 
 

end 
GO

