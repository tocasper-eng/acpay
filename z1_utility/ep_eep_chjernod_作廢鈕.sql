USE acpay
GO
IF OBJECT_ID(N'dbo.ep_eep_chjernod', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ep_eep_chjernoi;
GO
/* 
declare @chjernod nvarchar(99) 
exec .dbo.ep_eep_chjernod  'casper' , 'yu-cheng chuang','database','solution','computer' , @chjernod output 
print @chjernod 
*/
CREATE PROCEDURE dbo.ep_eep_chjernod
    @user      NVARCHAR(30),  -- 08+1=9
    @username  NVARCHAR(30),  -- 18+0=17
    @database  NVARCHAR(30),  -- 10
    @solution  NVARCHAR(30),  -- 10
    @computer  NVARCHAR(30),  -- 20
    @sqlpass   NVARCHAR(99) OUTPUT  -- 與原函式一致的長度限制
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @dt NVARCHAR(23);
    DECLARE @a  NVARCHAR(99);

    -- 與原函式相同的日期格式：style 121 = ODBC canonical (yyyy-mm-dd hh:mi:ss.mmm)
    SET @dt = CONVERT(VARCHAR(23), GETDATE(), 121);

    SET @a = 'Y'+ N'::' 
	        + ISNULL(@dt      ,'') + N'::' + ISNULL(@user    ,'') + N'::' + ISNULL(@username,'') + N'::'
            + ISNULL(@database,'') + N'::' + ISNULL(@solution,'') + N'::' + ISNULL(@computer,'');
    -- 若超過 99 會被隱性截斷；如不希望截斷，請把 @result/@a 長度加大，或使用 LEFT(@a, 99)
    SET @sqlpass = @a;

    -- 也 SELECT 一份，方便直接抓結果（可視需要移除）
    SELECT sqlpass = @sqlpass;
END
GO
