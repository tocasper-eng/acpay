--USE cfp
--GO
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_92i_00_eep_di]'))
   DROP TRIGGER [dbo].[tr_100_921_00_eep_di]
GO
create trigger tr_100_921_00_eep_di on eep_di
after insert 
as
begin 

update eep_di set menuflag='921_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_di.num = inserted.num 

end 


GO


