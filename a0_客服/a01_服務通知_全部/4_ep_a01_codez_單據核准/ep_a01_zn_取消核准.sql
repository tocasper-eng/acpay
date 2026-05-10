use acpay
go
go
--單據核准
if exists (select name from sysobjects where name = 'ep_a01_zn')
   drop procedure ep_a01_zn 
go
--exec .dbo.ep_a01_zn 'A01_00_0000000000002','Y' 
create procedure ep_a01_zn
(
@menuflag char(20) ,
@chjerno nvarchar(99) 
)
--casper--
as
begin


declare @chjernoz nvarchar(99) 
declare @iwno  char(10) 
--declare @chjernoz nvarchar(99)

select   
		  @iwno      =iwno , 
         @chjernoz = chjernoz 
from eep_iwh where menuflag = @menuflag 

 
 
--前端已檔，不必寫入主檔
if substring(isnull(@chjernoz,'') ,1,1) <> 'Y' return 
 
 set @chjernoz = 'N::' + isnull(@chjerno,'')  
 


--同步更新子檔

update eep_iwh set chjernoz = @chjernoz where menuflag = @menuflag 
--update eep_iwd set chjernoz = @chjernoz where iwno=@iwno 

insert into eep_logs(dt,menuflag,chjernoz) 
values ( GETDATE() , @menuflag,@chjernoz ) 

end 
GO

