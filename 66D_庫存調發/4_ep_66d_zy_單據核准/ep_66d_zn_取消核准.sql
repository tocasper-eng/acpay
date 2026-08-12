use acpay
go
go
--單據核准
if exists (select name from sysobjects where name = 'ep_66d_zn')
   drop procedure ep_66d_zn 
go
--exec .dbo.ep_66d_zn '66d_00_0000000000002','Y' 
create procedure ep_66d_zn
(
@menuflag char(20) ,
@chjerno nvarchar(99) 
)
--casper--
as
begin


declare @chjernoz nvarchar(99) 
declare @tdno  char(10) 
--declare @chjernoz nvarchar(99)

select   
		  @tdno      =tdno , 
         @chjernoz = chjernoz 
from eep_tdh where menuflag = @menuflag 

 
 
--前端已檔，不必寫入主檔
if substring(isnull(@chjernoz,'') ,1,1) <> 'Y' return 
 
 set @chjernoz = 'N::' + isnull(@chjerno,'')  
 


--同步更新子檔

update eep_tdh set chjernoz = @chjernoz where menuflag = @menuflag 
--update eep_tdd set chjernoz = @chjernoz where tdno=@tdno 

insert into eep_logs(dt,menuflag,chjernoz) 
values ( GETDATE() , @menuflag,@chjernoz ) 

end 
GO

