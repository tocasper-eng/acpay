--USE [cfp]
--GO
--exec .dbo.ep_91b_00
--exec .dbo.ep_92b_00

/****** Object:  StoredProcedure [dbo].[ep_91b_00]    Script Date: 2025/10/5 ¤U¤È 04:37:10 ******/
DROP PROCEDURE [dbo].[ep_91b_00]
GO
create procedure [dbo].[ep_91b_00]
as
begin
declare @name1     nvarchar(90)      declare @name2     nvarchar(90)      declare @name3     nvarchar(90)
declare @name4     nvarchar(90)      declare @name5     nvarchar(90)      declare @group1    char(01)
declare @group2    char(02)          declare @group3    char(03)          declare @group4    char(04)
declare @group5    char(05)          declare @status1   int               declare @status2   int 
declare @status3   int               declare @status4   int               declare @status5   int 
declare @compnm    nvarchar(96)      declare @num       bigint 
declare @num1      bigint            declare @num2      bigint            declare @num3      bigint 
declare @num4      bigint            declare @num5      bigint

 
update eep_depa set group1 = substring(depano,1,1) where isnull(group1,'')=''
update eep_depa set group2 = substring(depano,1,2) where isnull(group2,'')=''
update eep_depa set group3 = substring(depano,1,3) where isnull(group3,'')=''
update eep_depa set group4 = substring(depano,1,4) where isnull(group4,'')=''
update eep_depa set group5 = substring(depano,1,5) where isnull(group5,'')=''


declare cur_91b1 cursor for 
select group1,max(num) from eep_depa group by group1 
open    cur_91b1
fetch next from cur_91b1 into @group1,@num1 
set @status1 = @@fetch_status
while ( @status1 <> -1 )
begin

   select top 1 @name1=name1 from eep_depa where num = @num1 
   update eep_depa set name1=@name1 
   where group1=@group1 and num <> @num1 and isnull(name1,'')='' 

   declare cur_91b2 cursor for 
   select group2,max(num) from eep_depa where group2 = @group2 group by group2 
   open    cur_91b2
   fetch next from cur_91b2 into @group2,@num2 
   set @status2 = @@fetch_status
   while ( @status2 <> -1 )
   begin

      select top 1 @name2=name2 from eep_depa where num = @num2 

      update eep_depa set name2=@name2 
      where group1=@group1 and group2=@group2 and num <> @num2 and isnull(name2,'')='' 
  
      declare cur_91b3 cursor for 
      select group3,max(num) from eep_depa where group2 = @group2 group by group3 
      open    cur_91b3
      fetch next from cur_91b3 into @group3,@num3 
      set @status3 = @@fetch_status
      while ( @status3 <> -1 )
      begin
         select top 1 @name2=name2 from eep_depa where num = @num3 

         update eep_depa set name3=@name3 
         where group1=@group1 and group2=@group2 and group3=@group3 
		 and num <> @num3 and isnull(name3,'')='' 
	  
         declare cur_91b4 cursor for 
         select group4,max(num) from eep_depa 
		 where group1 = @group1 and group2 = @group2 and group3 = @group3 group by group4 
         open    cur_91b4
         fetch next from cur_91b4 into @group4,@num4 
         set @status4 = @@fetch_status
         while ( @status4 <> -1 )
         begin
            select top 1 @name4=name4 from eep_depa where num = @num4 

            update eep_depa set name4=@name4 
            where group1=@group1 and group2=@group2 and group3=@group3  and group4=@group4 
   		    and num <> @num4 and isnull(name4,'')='' 
 
            declare cur_91b5 cursor for 
            select group5,max(num) from eep_depa 
   		    where group1 = @group1 and group2 = @group2 and group3 = @group3 and group4 = @group4 
			group by group5 
            open    cur_91b5
            fetch next from cur_91b5 into @group5,@num5 
            set @status5 = @@fetch_status
            while ( @status5 <> -1 )
            begin

               select top 1 @name5=name5 from eep_depa where num = @num5 

               update eep_depa set name5=@name5 
               where group1=@group1 and group2=@group2 and group3=@group3  and group4=@group4 
      		   and   group5=@group5 and num <> @num5 and isnull(name5,'')='' 

            fetch next from cur_91b5 into @group5,@num5
            set @status5 = @@fetch_status
            end
            close cur_91b5
            deallocate cur_91b5

         fetch next from cur_91b4 into @group4,@num4
         set @status4 = @@fetch_status
         end
         close cur_91b4
         deallocate cur_91b4

      fetch next from cur_91b3 into @group3,@num3
      set @status3 = @@fetch_status
      end
      close cur_91b3
      deallocate cur_91b3
   
   fetch next from cur_91b2 into @group2,@num2
   set @status2 = @@fetch_status
   end
   close cur_91b2
   deallocate cur_91b2

fetch next from cur_91b1 into @group1,@num1 
set @status1 = @@fetch_status
end
close cur_91b1
deallocate cur_91b1

end 


GO


