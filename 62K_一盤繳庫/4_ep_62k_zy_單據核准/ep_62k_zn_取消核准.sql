use acpay
go
go
--單據核准
if exists (select name from sysobjects where name = 'ep_62k_zn')
   drop procedure ep_62k_zn 
go
--exec .dbo.ep_62k_zn '62k_00_0000000000002','Y' 
create procedure ep_62k_zn
(
@menuflag char(20) ,
@chjerno nvarchar(99) 
)
--casper--
as
begin


declare @chjernoz nvarchar(99) 
declare @trno  char(10) 
--declare @chjernoz nvarchar(99)

select   
		  @trno      =trno , 
         @chjernoz = chjernoz 
from eep_trh where menuflag = @menuflag 

 
 
--前端已檔，不必寫入主檔
if substring(isnull(@chjernoz,'') ,1,1) <> 'Y' return 
 
 set @chjernoz = 'N::' + isnull(@chjerno,'')  
 


--同步更新子檔

update eep_trh set chjernoz = @chjernoz where menuflag = @menuflag 
--update eep_trd set chjernoz = @chjernoz where trno=@trno 


exec .dbo.ep_62k_itio  @menuflag,@chjernoz 


 

insert into eep_logs(dt,menuflag,chjernoz) 
values ( GETDATE() , @menuflag,@chjernoz ) 

end 
GO

