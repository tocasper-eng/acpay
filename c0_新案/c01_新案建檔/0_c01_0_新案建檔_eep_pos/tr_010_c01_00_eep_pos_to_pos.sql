USE acpay 

GO

--select * from zip 

 
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_010_c01_00_eep_pos_to_pos]'))
   DROP TRIGGER [dbo].[tr_010_c01_00_eep_pos_to_pos]
GO
create trigger tr_010_c01_00_eep_pos_to_pos on eep_pos 
after update  
as
begin 

declare @flowflag nvarchar(50)  declare @zipcode  char(01) 
declare @c1       char(01)      declare @契約編號 nvarchar(10) 
declare @yy       char(02)      declare @標的物地址 nvarchar(100) 
declare @契約狀態 nvarchar(20) 
declare @fixed    char(04)      declare @currnum int 


set @yy = substring(chjer.dbo.uf_dtos(GETDATE()),3,2) 


select top 1 @flowflag = flowflag, @標的物地址=標的物地址,@契約狀態=契約狀態
from inserted 

if SUBSTRING(@flowflag,1,1) <>  'Z' return 

if @契約狀態= '租賃'
   set @c1 = 'P'
else 
   set @c1 = 'Q'



 select top 1 @zipcode=zipcode from zip where  @標的物地址 LIKE '%'+zipname+'%' order by orders 
 
 set @fixed = @zipcode  + @yy + @c1
 
 select @currnum = CURRNUM from SYSAUTONUM where AUTOID = '契約編號' and FIXED = @fixed 
 
 if ISNULL(@currnum ,0) = 0 
begin 
    insert into SYSAUTONUM( AUTOID, FIXED , CURRNUM) values ('契約編號'  , @fixed , 0) 

end 

set @currnum = ISNULL(@currnum,0)+1 

set @契約編號= @fixed  + chjer.dbo.uf_strzero(@currnum,4) 

update SYSAUTONUM set CURRNUM = @currnum where AUTOID = '契約編號' and FIXED = @fixed 

insert into pos ( 
契約狀態        ,契約編號        ,
部門代碼	    ,
部門名稱	    ,
公司代碼	    ,
公司名稱	    ,
客戶發票抬頭    ,	
狀況代碼	    ,
狀況開通	    ,
營業員編號      ,
營業員名稱      ,
系統別	        ,
系統別名稱	    ,
契約書客戶名稱	,
客戶發票地址	,
標的物名稱	    ,
標的物地址	    ,
客戶統編	    ,
連鎖性客戶編號	,
連鎖性客戶名稱	,
負責人	        ,
負責人電話	    ,
負責人手機	    ,
收款連絡人	    ,
收款連絡人電話	,
收款連絡人手機	,
拜訪連絡人	    ,
拜訪連絡人電話	,
拜訪連絡人手機	,
拜訪公司代碼	 
) 

select top 1 
契約狀態        ,@契約編號        ,
部門代碼	    ,
部門名稱	    ,
公司代碼	    ,
公司名稱	    ,
客戶發票抬頭    ,	
狀況代碼	    ,
狀況開通	    ,
營業員編號      ,
營業員名稱      ,
系統別	        ,
系統別名稱	    ,
契約書客戶名稱	,
客戶發票地址	,
標的物名稱	    ,
標的物地址	    ,
客戶統編	    ,
連鎖性客戶編號	,
連鎖性客戶名稱	,
負責人	        ,
負責人電話	    ,
負責人手機	    ,
收款連絡人	    ,
收款連絡人電話	,
收款連絡人手機	,
拜訪連絡人	    ,
拜訪連絡人電話	,
拜訪連絡人手機	,
拜訪公司代碼	 

from inserted 
end 


GO


