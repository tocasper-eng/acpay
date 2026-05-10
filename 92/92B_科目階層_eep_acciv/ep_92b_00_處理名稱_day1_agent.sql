
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ep_92b_00]') AND type in (N'P', N'PC'))
    DROP PROCEDURE ep_92b_00
GO
--exec .dbo.ep_92b
--select * from eep_acci order by accino1 , accino2 , accino3 , accino4 , accino5 , accino 
create procedure ep_92b_00
as
begin
declare @accinm1     nvarchar(90)      declare @accinm2     nvarchar(90)      declare @accinm3     nvarchar(90)
declare @accinm4     nvarchar(90)      declare @accinm5     nvarchar(90)      declare @accino1    char(01)
declare @accino2    char(02)          declare @accino3    char(03)          declare @accino4    char(04)
declare @accino5    char(05)          declare @status1   int               declare @status2   int 
declare @status3   int               declare @status4   int               declare @status5   int 
declare @compnm    nvarchar(96)      declare @num       bigint 
declare @num1      bigint            declare @num2      bigint            declare @num3      bigint 
declare @num4      bigint            declare @num5      bigint

 
update eep_acci set accino1 = substring(accino,1,1) where isnull(accino1,'')=''
update eep_acci set accino2 = substring(accino,1,2) where isnull(accino2,'')=''
update eep_acci set accino3 = substring(accino,1,3) where isnull(accino3,'')=''
update eep_acci set accino4 = substring(accino,1,4) where isnull(accino4,'')=''
update eep_acci set accino5 = substring(accino,1,5) where isnull(accino5,'')=''


declare cur_92b1 cursor for 
select accino1,max(num) from eep_acci group by accino1 
open    cur_92b1
fetch next from cur_92b1 into @accino1,@num1 
set @status1 = @@fetch_status
while ( @status1 <> -1 )
begin

   select top 1 @accinm1=accinm1 from eep_acci where num = @num1 
   update eep_acci set accinm1=@accinm1 
   where accino1=@accino1 and num <> @num1 and isnull(accinm1,'')='' 

   declare cur_92b2 cursor for 
   select accino2,max(num) from eep_acci where accino2 = @accino2 group by accino2 
   open    cur_92b2
   fetch next from cur_92b2 into @accino2,@num2 
   set @status2 = @@fetch_status
   while ( @status2 <> -1 )
   begin

      select top 1 @accinm2=accinm2 from eep_acci where num = @num2 

      update eep_acci set accinm2=@accinm2 
      where accino1=@accino1 and accino2=@accino2 and num <> @num2 and isnull(accinm2,'')='' 
  
      declare cur_92b3 cursor for 
      select accino3,max(num) from eep_acci where accino2 = @accino2 group by accino3 
      open    cur_92b3
      fetch next from cur_92b3 into @accino3,@num3 
      set @status3 = @@fetch_status
      while ( @status3 <> -1 )
      begin
         select top 1 @accinm2=accinm2 from eep_acci where num = @num3 

         update eep_acci set accinm3=@accinm3 
         where accino1=@accino1 and accino2=@accino2 and accino3=@accino3 
		 and num <> @num3 and isnull(accinm3,'')='' 
	  
         declare cur_92b4 cursor for 
         select accino4,max(num) from eep_acci 
		 where accino1 = @accino1 and accino2 = @accino2 and accino3 = @accino3 group  by accino4 
         open    cur_92b4
         fetch next from cur_92b4 into @accino4,@num4 
         set @status4 = @@fetch_status
         while ( @status4 <> -1 )
         begin
            select top 1 @accinm4=accinm4 from eep_acci where num = @num4 

            update eep_acci set accinm4=@accinm4 
            where accino1=@accino1 and accino2=@accino2 and accino3=@accino3  and accino4=@accino4 
   		    and num <> @num4 and isnull(accinm4,'')='' 
 
            declare cur_92b5 cursor for 
            select accino5,max(num) from eep_acci 
   		    where accino1 = @accino1 and accino2 = @accino2 and accino3 = @accino3 and accino4 = @accino4 
			group by accino5 
            open    cur_92b5
            fetch next from cur_92b5 into @accino5,@num5 
            set @status5 = @@fetch_status
            while ( @status5 <> -1 )
            begin

               select top 1 @accinm5=accinm5 from eep_acci where num = @num5 

               update eep_acci set accinm5=@accinm5 
               where accino1=@accino1 and accino2=@accino2 and accino3=@accino3  and accino4=@accino4 
      		   and   accino5=@accino5 and num <> @num5 and isnull(accinm5,'')='' 

            fetch next from cur_92b5 into @accino5,@num5
            set @status5 = @@fetch_status
            end
            close cur_92b5
            deallocate cur_92b5

         fetch next from cur_92b4 into @accino4,@num4
         set @status4 = @@fetch_status
         end
         close cur_92b4
         deallocate cur_92b4

      fetch next from cur_92b3 into @accino3,@num3
      set @status3 = @@fetch_status
      end
      close cur_92b3
      deallocate cur_92b3
   
   fetch next from cur_92b2 into @accino2,@num2
   set @status2 = @@fetch_status
   end
   close cur_92b2
   deallocate cur_92b2

fetch next from cur_92b1 into @accino1,@num1 
set @status1 = @@fetch_status
end
close cur_92b1
deallocate cur_92b1

end 


GO


