  use acpay
go
go
--單據核准
if exists (select name from sysobjects where name = 'ep_62k_zy')
   drop procedure ep_62k_zy 
go

--select * from eep_trh 

--exec .dbo.ep_62k_zy '62k_00_0000000000004','Y' 
create procedure ep_62k_zy
(
@menuflag char(20),
@chjerno  nvarchar(99) 
)
--casper--
as
begin

 

declare @trno      char(10)
declare @chjernoz  nvarchar(100) 
declare @需要派工  nvarchar(20) 
declare @工單編號  nvarchar(20) 

select  @chjernoz  = chjernoz ,
		@trno      =trno  
from eep_trh where menuflag = @menuflag 


if substring(isnull(@chjernoz,'') ,1,1) = 'Y' return 

 
set @chjernoz = 'Y::' + isnull(@chjerno,'') 
 
 
update eep_trh set chjernoz = @chjernoz where menuflag = @menuflag 
--update eep_trd set chjernoz = @chjernoz where trno=@trno 

--select @需要派工=需要派工 ,@工單編號=工單編號
--from eep_trh where menuflag = @menuflag 

--if substring(ISNULL(@需要派工,''),1,1)='Y' 
--begin 
--   if ISNULL(@工單編號,'')= '' 
--	  update eep_trh set 工單編號=.dbo.uf_工單編號( trdate, num) 
--	  where menuflag = @menuflag 
--end 
--else
--begin 
--   update eep_trh set 工單編號=''  
--   where menuflag = @menuflag 
--end 
--   --
exec .dbo.ep_62k_itio  @menuflag,@chjernoz 

   --
insert into eep_logs(dt,menuflag,chjernoz) 
values ( GETDATE() , @menuflag,@chjernoz ) 

end 
GO

