--use cfp 
--go 
--insert into eep_cust(custno,custnm) values ('123456','eee')
--select * from eep_cust 
--select * from timer_eep
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_100_95p_00_eep_pugrp]'))
   DROP TRIGGER [dbo].[tr_100_95p_00_eep_pugrp]
GO
create trigger tr_100_95p_00_eep_pugrp on eep_pugrp
after insert 
as
begin 

update eep_pugrp set menuflag='95p_'+'00_'+.dbo.uf_strzero(inserted.num,13)
FROM inserted 
where eep_pugrp.num = inserted.num 

end 


GO


