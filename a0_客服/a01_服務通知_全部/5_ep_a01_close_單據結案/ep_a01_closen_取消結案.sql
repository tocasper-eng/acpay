use acpay
go
go
--單據核准
if exists (select name from sysobjects where name = 'ep_a01_closen')
   drop procedure ep_a01_closen 
go
--exec .dbo.ep_a01_closen 'A01_00_0000000000014','dddd' 
--select chjernoc,chjernoz,menuflag, * from eep_iwh where menuflag= 'A01_00_0000000000014'

create procedure ep_a01_closen
(
@menuflag char(20) ,
@chjerno  nvarchar(99) 
)
--casper--
as
begin


declare @chjernoc nvarchar(99) 
declare @chjernoz nvarchar(99)

select  @chjernoc = chjernoc,  
        @chjernoz = chjernoz 
from eep_iwh where menuflag = @menuflag 

--未結案，不必執行


if substring(isnull(@chjernoc,'') ,1,1) <> 'Y' return

--前端已檔，不必寫入主檔
if substring(isnull(@chjernoz,'') ,1,1) <> 'Y' return 

--新的結案資訊
set @chjernoc = 'N::' + isnull(@chjerno,'') 



--同步更新子檔
update eep_iwh   set chjernoc = @chjernoc

where menuflag = @menuflag 

insert into eep_logs(dt,menuflag,chjernoc) 
values ( GETDATE() , @menuflag,@chjernoc ) 
end 
GO

