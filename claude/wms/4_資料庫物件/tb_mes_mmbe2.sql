--USE [gemio_wms]
--GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mes_mmbe2]') AND type in (N'U'))
    DROP TABLE [dbo].[mes_mmbe2]
GO
CREATE TABLE [dbo].[mes_mmbe2](
	[itemno]  [nvarchar](40)             NOT NULL,--物料編號
	[plantno] [nvarchar](40)             NOT NULL,--工廠代碼
	[OpeningQuantity]  [decimal](18,2)   NOT NULL,--期初數量
	[InboundQuantity]  [decimal](18,2)   NOT NULL,--本期入庫
	[OutboundQuantity] [decimal](18,2)   NOT NULL,--本期出庫
	[ClosingQuantity]  [decimal](18,2)   NOT NULL --期末數量
constraint pk_mes_mmbe2  primary key ( itemno,plantno)
)
GO
CREATE INDEX in_mes_mmbe2_itemno  ON mes_mmbe2( itemno   )
CREATE INDEX in_mes_mmbe2_plantno ON mes_mmbe2( plantno  )
GO
