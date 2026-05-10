--use cfp 
--go

if exists (select name from sysobjects where name = 'eep_921')
   drop procedure eep_921
go
--exec chjer.dbo.eep_921 980 
create procedure eep_921
(
@menuflag char(20) 
)
--casper--
as
begin

  update eep_di set remark = '1,'+isnull(remark,'')  where menuflag = @menuflag  

end 
GO

