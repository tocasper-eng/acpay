 

/****** Object:  UserDefinedFunction [dbo].[uf_dtos_odbc_23]    Script Date: 2018/7/10 上午 10:03:50 ******/
DROP FUNCTION [dbo].[uf_dtos_odbc_23]
GO

/****** Object:  UserDefinedFunction [dbo].[uf_dtos_odbc_23]    Script Date: 2018/7/10 上午 10:03:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 CREATE function  [dbo].[uf_dtos_odbc_23]
(
  @date datetime
)
returns nvarchar(23)
--casper--
--傳入年月日時分秒的datetime型態，傳回如：2005-12-01 16:05:56.937的二十三碼年月日時分秒(含小數秒)的日期字串。
   AS
begin

  declare @dtos_odbc nvarchar(23)

  set @dtos_odbc = convert(varchar(30),@date,121)


  return ( @dtos_odbc )

end
GO


