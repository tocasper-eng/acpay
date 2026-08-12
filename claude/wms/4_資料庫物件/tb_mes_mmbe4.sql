--USE [gemio_wms]
--GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mes_mmbe4]') AND type in (N'U'))
    DROP TABLE [dbo].[mes_mmbe4]
GO
CREATE TABLE [dbo].[mes_mmbe4](
	[itemno] [nvarchar](40)            NOT NULL,--物料編號
	[posino] [nvarchar](40)            NOT NULL,--儲位代碼
	[OpeningQuantity]  [decimal](18,2) NOT NULL,--期初數量
	[InboundQuantity]  [decimal](18,2) NOT NULL,--本期入庫
	[OutboundQuantity] [decimal](18,2) NOT NULL,--本期出庫
	[ClosingQuantity]  [decimal](18,2) NOT NULL --期末數量
constraint pk_mes_mmbe4  primary key ( itemno,posino)
)
GO
CREATE INDEX in_mes_mmbe4_posino ON mes_mmbe4( posino  )
CREATE INDEX in_mes_mmbe4_itemno ON mes_mmbe4( itemno  )
GO
