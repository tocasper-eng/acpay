--use cfp 
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_94p_00_eep_sdgrp]'))
   DROP TRIGGER [dbo].[tr_100_94p_00_eep_sdgrp]
GO
create trigger tr_100_94p_00_eep_sdgrp on eep_sdgrp
after insert 
as
begin 

update eep_sdgrp set menuflag='94p_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_sdgrp.num = inserted.num 

end 


GO


