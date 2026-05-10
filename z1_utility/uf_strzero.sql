/****** Object:  UserDefinedFunction [dbo].[uf_strzero]    Script Date: 2018/7/30 下午 06:19:39 ******/
DROP FUNCTION [dbo].[uf_strzero]
GO

/****** Object:  UserDefinedFunction [dbo].[uf_strzero]    Script Date: 2018/7/30 下午 06:19:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 CREATE function  [dbo].[uf_strzero] (@i1 integer,@i2 integer)
returns nvarchar(20)
--casper--06UNF\S
   AS
begin
--傳入數字字串及傳回位數，傳回20碼的左側補滿0 的整數數字。
--版權所有：高明資訊  設計人：莊玉成  建立日期：20030903  最後異動：20041112 --
if @i1 is null set @i1 = 0  --20111107 casper
if @i2 > 20  set @i2 = 20
--
return (right('0000000000000000000000'+convert(varchar(20),@i1),@i2))--傳回20碼的左側補滿0 的數字字串。
end

GO


