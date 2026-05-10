USE cfp 
GO
DROP PROCEDURE [dbo].[ep_timer_void]
GO
create procedure [dbo].[ep_timer_void]
as
begin
           
declare @time   char(08)      declare @time0       char(08)
declare @time1  char(08)      declare @menuflag    char(20) 
declare @sql    nvarchar(512) declare @sec    int  
declare @hrs    int           declare @menunum_det char(02) 
 
select  top 1 @menuflag = menuflag from timer_void
where ok = 'N'
and len(isnull(menuflag,''))=20 
order by  dt  

update TOP (1) timer_void set ok='W' , dt = getdate() 
where menuflag = @menuflag and ok = 'N'

SET @sql = '.dbo.ep_' + substring(@menuflag,1,3) + '_vz_' + ' ''' + @menuflag + '''' 

EXEC sp_executesql @sql

if @@ERROR = 0   
   update TOP (1) timer_void set ok='Y' , dt = getdate() 
   where menuflag = @menuflag and ok = 'W' 


end

GO


