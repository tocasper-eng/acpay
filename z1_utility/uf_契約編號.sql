 
/****** Object:  UserDefinedFunction [dbo].[uf_dtos14]    Script Date: 2018/7/10 上午 10:04:58 ******/
DROP FUNCTION  uf_契約編號
GO
 
 --print .dbo.uf_契約編號('租賃', '新北市淡水')  

 
 CREATE function  dbo.uf_契約編號
(
 @契約狀態 nvarchar(20) , 
 @標的物地址 nvarchar(100) 
  
)
returns nvarchar(20)
 
   AS
begin

 

declare @flowflag nvarchar(50)  declare @zipcode  char(01) 
declare @c1       char(01)      declare @契約編號 nvarchar(10) 
declare @yy       char(02)       
 
declare @fixed    char(04)      declare @currnum int 


set @yy = substring(chjer.dbo.uf_dtos(GETDATE()),3,2) 

 
if @契約狀態= '租賃'
   set @c1 = 'P'
else 
   set @c1 = 'Q'



 select top 1 @zipcode=zipcode from zip where  @標的物地址 LIKE '%'+zipname+'%' order by orders 
 
 set @fixed = @c1 + @yy + @zipcode 
 
  return (@fixed )

end
GO


