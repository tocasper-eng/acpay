use acpay
go
go
--單據核准
if exists (select name from sysobjects where name = 'ep_a01_zy')
   drop procedure ep_a01_zy 
go

--select * from eep_iwh 

--exec .dbo.ep_a01_zy 'A01_00_0000000000004','Y' 
create procedure ep_a01_zy
(
@menuflag char(20),
@chjerno  nvarchar(99) 
)
--casper--
as
begin

 

declare @iwno      char(10)
declare @chjernoz  nvarchar(100) 
declare @需要派工  nvarchar(20) 
declare @工單編號  nvarchar(20) 

select  @chjernoz  = chjernoz ,
		@iwno      =iwno  
from eep_iwh where menuflag = @menuflag 


if substring(isnull(@chjernoz,'') ,1,1) = 'Y' return 

 
set @chjernoz = 'Y::' + isnull(@chjerno,'') 
 
 
update eep_iwh set chjernoz = @chjernoz where menuflag = @menuflag 
--update eep_iwd set chjernoz = @chjernoz where iwno=@iwno 

select @需要派工=需要派工 ,@工單編號=工單編號
from eep_iwh where menuflag = @menuflag 

if substring(ISNULL(@需要派工,''),1,1)='Y' 
begin 
   if ISNULL(@工單編號,'')= '' 
	  update eep_iwh set 工單編號=.dbo.uf_工單編號( iwdate, num) 
	  where menuflag = @menuflag 
end 
else
begin 
   update eep_iwh set 工單編號=''  
   where menuflag = @menuflag 
end 
   --
   --
   --
insert into eep_logs(dt,menuflag,chjernoz) 
values ( GETDATE() , @menuflag,@chjernoz ) 

end 
GO

