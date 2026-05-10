--use cfp
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_93i_00_eep_line]'))
   DROP TRIGGER tr_100_93i_00_eep_line
GO
create trigger tr_100_93i_00_eep_line on eep_line 
after insert 
as
begin 

update eep_line set menuflag='93I_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_line.num = inserted.num 

end 


GO


