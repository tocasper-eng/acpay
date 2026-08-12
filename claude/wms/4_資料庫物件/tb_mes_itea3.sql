--USE [gemio_wms]
--GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mes_itea3]') AND type in (N'U'))
    DROP TABLE [dbo].[mes_itea3]
GO
CREATE TABLE [dbo].[mes_itea3](
	[iodate] [char](08)                NOT NULL,--異動日期
	[itemno] [nvarchar](40)            NOT NULL,--物料編號
	[wareno] [nvarchar](40)            NOT NULL,--倉庫代碼
	[OpeningQuantity]  [decimal](18,2) NOT NULL,--期初數量
	[InboundQuantity]  [decimal](18,2) NOT NULL,--本期入庫
	[OutboundQuantity] [decimal](18,2) NOT NULL,--本期出庫
	[ClosingQuantity]  [decimal](18,2) NOT NULL --期末數量
constraint pk_mes_itea3  primary key ( iodate,itemno,wareno)
)
GO
CREATE INDEX in_mes_itea3_wareno ON mes_itea3( wareno  )
CREATE INDEX in_mes_itea3_itemno ON mes_itea3( itemno  )
GO
