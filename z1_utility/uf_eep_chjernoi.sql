USE acpay 
GO
DROP FUNCTION [dbo].[uf_eep_chjernoi]
GO
/*
print dbo.uf_eep_chjernoi( 'casper' , 'yu-cheng chuang','database','solution','computer')
print len(dbo.uf_eep_chjernoi( 'casper' , 'yu-cheng chuang','database','solution','computer'))
*/
create function [dbo].[uf_eep_chjernoi] 
(
@user     nvarchar(30),--08+1= 9
@username nvarchar(30),--18+0=17
@database nvarchar(30),--10
@solution nvarchar(30),--10
@computer nvarchar(30) --20
)
returns nvarchar(99) 
--casper--06UNF\C
as
begin
declare @dt nvarchar(23) 
declare @a  nvarchar(99) 
set @dt = convert(varchar(23),getdate(),121)


set @a =  isnull(@dt      ,'')+'::'+isnull(@user    ,'')+'::'+isnull(@username,'')+'::'
        + isnull(@database,'')+'::'+isnull(@solution,'')+'::'+isnull(@computer,'')
return ( @a )
end


GO


