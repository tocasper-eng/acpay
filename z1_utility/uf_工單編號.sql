 
/****** Object:  UserDefinedFunction [dbo].[uf_dtos14]    Script Date: 2018/7/10 上午 10:04:58 ******/
DROP FUNCTION  dbo.uf_工單編號
GO
 
 --print .dbo.uf_工單編號( getdate(), 123456) 

  
 
 CREATE function  dbo.uf_工單編號
(
  @dt  datetime , 
  @num bigint 
  
)
returns nvarchar(20)
 
   AS
begin

  if @dt is null   
     set @dt = GETDATE() 
  ----------------------------------------------------------
  declare @datec     nvarchar(08)  declare @timec     nvarchar(04)
  declare @工單號碼  nvarchar(20)  declare @dtos_odbc nvarchar(23)
  ----------------------------------------------------------
  set @dtos_odbc = chjer.dbo.uf_dtos_odbc_23(@dt)

  set @timec = substring(@dtos_odbc,12,02) + 
               substring(@dtos_odbc,15,02)  
 

  set @datec = substring(@dtos_odbc,01,04) +
               substring(@dtos_odbc,06,02) +
               substring(@dtos_odbc,09,02)

  set @工單號碼 = @datec +'-'+ @timec +'-'+.dbo.uf_strzero(@num,6) 

  return ( @工單號碼 )

end
GO


