USE cfp 
GO
DROP PROCEDURE [dbo].[ep_timer_wono2]
GO
create procedure [dbo].[ep_timer_wono2]
as
begin
           
declare @time   char(08)      declare @time0       char(08)
declare @time1  char(08)      declare @menuflag    char(20) 
declare @sql    nvarchar(512) declare @sec    int  
declare @hrs    int           declare @menunum_det char(02) 
 
select  top 1 @menuflag = menuflag from timer_wono2
where ok = 'N'
and len(isnull(menuflag,''))=20 
order by  dt  

update TOP (1) timer_wono2 set ok='W' , dt = getdate() 
where menuflag = @menuflag and ok = 'N'

SET @sql = '.dbo.ep_' + substring(@menuflag,1,6) + '_wono2_' + ' ''' + @menuflag + '''' 

EXEC sp_executesql @sql

if @@ERROR = 0   
   update TOP (1) timer_wono2 set ok='Y' , dt = getdate() 
   where menuflag = @menuflag and ok = 'W' 


end

GO


