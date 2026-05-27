use acpay 

go 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pos_log_detail]') AND type in (N'U'))
   DROP TABLE  pos_log_detail 
GO
CREATE TABLE pos_log_detail(

	fieldname    nvarchar(20)            not NULL,
	newvalue     nvarchar(max)               NULL,
	oldvalue     nvarchar(max)               NULL, 
	menuflag     nvarchar(50)            not NULL,
	契約狀態     nvarchar(50)            not NULL,
	num_pos      bigint                 not NULL,
	num_pos_log  bigint                 not NULL,
    num          bigint IDENTITY(1,1)   NOT NULL,
 
constraint pk_pos_log_detail_num  primary key ( num  )  
)
 
GO 
CREATE unique INDEX in_pos_log_detail_num_pos_log           ON pos_log_detail (  num       )
cREATE        INDEX in_pos_log_detail_契約狀態              ON pos_log_detail ( 契約狀態   )
CREATE unique INDEX in_pos_log_detail_menuflag_fieldname    ON pos_log_detail ( menuflag,fieldname   )
GO

 