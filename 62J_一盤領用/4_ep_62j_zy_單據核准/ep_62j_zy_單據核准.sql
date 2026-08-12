--USE [acpay]
--GO

/****** 物件:  StoredProcedure [dbo].[ep_62j_zy]    指令碼日期: 7/6/2026 8:46:40 AM ******/
DROP PROCEDURE [dbo].[ep_62j_zy]
GO

 
--select * from eep_toh 

--exec .dbo.ep_62j_zy '62j_00_0000000000004','Y' 
create procedure [dbo].[ep_62j_zy]
(
@menuflag char(20),
@chjerno  nvarchar(99) 
)
--casper--
as
begin

 

declare @tono      char(10)
declare @chjernoz  nvarchar(100) 
declare @需要派工  nvarchar(20) 
declare @工單編號  nvarchar(20) 

select  @chjernoz  = chjernoz ,
		@tono      =tono  
from eep_toh where menuflag = @menuflag 


if substring(isnull(@chjernoz,'') ,1,1) = 'Y' return 

 
set @chjernoz = 'Y::' + isnull(@chjerno,'') 
 
 
update eep_toh set chjernoz = @chjernoz where menuflag = @menuflag 
--update eep_Tod set chjernoz = @chjernoz where tono=@tono 

--select @需要派工=需要派工 ,@工單編號=工單編號
--from eep_toh where menuflag = @menuflag 

--if substring(ISNULL(@需要派工,''),1,1)='Y' 
--begin 
--   if ISNULL(@工單編號,'')= '' 
--	  update eep_toh set 工單編號=.dbo.uf_工單編號( trdate, num) 
--	  where menuflag = @menuflag 
--end 
--else
--begin 
--   update eep_toh set 工單編號=''  
--   where menuflag = @menuflag 
--end 
--   --
exec .dbo.ep_62j_itio  @menuflag,@chjernoz 

   --
insert into eep_logs(dt,menuflag,chjernoz) 
values ( GETDATE() , @menuflag,@chjernoz ) 

end 
GO


