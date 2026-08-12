--USE [gemio_wms]
--GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mes_mmbe3]') AND type in (N'U'))
    DROP TABLE [dbo].[mes_mmbe3]
GO
CREATE TABLE [dbo].[mes_mmbe3](
	[itemno] [nvarchar](40)            NOT NULL,--物料編號
	[wareno] [nvarchar](40)            NOT NULL,--倉庫代碼
	[OpeningQuantity]  [decimal](18,2) NOT NULL,--期初數量
	[InboundQuantity]  [decimal](18,2) NOT NULL,--本期入庫
	[OutboundQuantity] [decimal](18,2) NOT NULL,--本期出庫
	[ClosingQuantity]  [decimal](18,2) NOT NULL --期末數量
constraint pk_mes_mmbe3  primary key (itemno,wareno)
)
GO
CREATE INDEX in_mes_mmbe3_wareno ON mes_mmbe3( wareno  )
CREATE INDEX in_mes_mmbe3_itemno ON mes_mmbe3( itemno  )
GO
