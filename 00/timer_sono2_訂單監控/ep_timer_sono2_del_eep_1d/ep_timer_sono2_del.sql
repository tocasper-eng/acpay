USE cfp 
GO
-- exec .dbo.xp_timer_sono2_del 
DROP PROCEDURE [dbo].[ep_timer_sono2_del]
GO
create procedure [dbo].[ep_timer_sono2_del]
as
begin
           
declare @time   char(08)      declare @time0       char(08)
declare @time1  char(08)      declare @menuflag    char(20) 
declare @sql    nvarchar(512) declare @sec    int  
declare @hrs    int           declare @menunum_det char(02) 
 
 
    DELETE  
    FROM timer_sono2
    WHERE ISNULL(ok,'') = 'Y';


end

GO


