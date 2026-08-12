use acpay
go
go
--單據核准
if exists (select name from sysobjects where name = 'ep_66d_zy')
   drop procedure ep_66d_zy 
go

--select * from eep_tdh 

--exec .dbo.ep_66d_zy '66d_00_0000000000004','Y' 
create procedure ep_66d_zy
(
@menuflag char(20),
@chjerno  nvarchar(99) 
)
--casper--
as
begin

 

declare @tdno      char(10)
declare @chjernoz  nvarchar(100) 
declare @需要派工  nvarchar(20) 
declare @工單編號  nvarchar(20) 

select  @chjernoz  = chjernoz ,
		@tdno      =tdno  
from eep_tdh where menuflag = @menuflag 


if substring(isnull(@chjernoz,'') ,1,1) = 'Y' return 

 
set @chjernoz = 'Y::' + isnull(@chjerno,'') 
 
 
update eep_tdh set chjernoz = @chjernoz where menuflag = @menuflag 
--update eep_tdd set chjernoz = @chjernoz where tdno=@tdno 

--select @需要派工=需要派工 ,@工單編號=工單編號
--from eep_tdh where menuflag = @menuflag 

--if substring(ISNULL(@需要派工,''),1,1)='Y' 
--begin 
--   if ISNULL(@工單編號,'')= '' 
--	  update eep_tdh set 工單編號=.dbo.uf_工單編號( tddate, num) 
--	  where menuflag = @menuflag 
--end 
--else
--begin 
--   update eep_tdh set 工單編號=''  
--   where menuflag = @menuflag 
--end 
--   --
   --
   --
insert into eep_logs(dt,menuflag,chjernoz) 
values ( GETDATE() , @menuflag,@chjernoz ) 

end 
GO

