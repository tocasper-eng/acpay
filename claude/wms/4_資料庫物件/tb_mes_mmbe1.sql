--USE [gemio_wms]
--GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mes_mmbe1]') AND type in (N'U'))
    DROP TABLE [dbo].[mes_mmbe1]
GO
CREATE TABLE [dbo].[mes_mmbe1](
	[itemno] [nvarchar](40)            NOT NULL,--物料編號
	[compno] [nvarchar](40)            NOT NULL,--公司代碼
	[OpeningQuantity]  [decimal](18,2) NOT NULL,--期初數量
	[InboundQuantity]  [decimal](18,2) NOT NULL,--本期入庫
	[OutboundQuantity] [decimal](18,2) NOT NULL,--本期出庫
	[ClosingQuantity]  [decimal](18,2) NOT NULL --期末數量
constraint pk_mes_mmbe1  primary key ( itemno,compno)
)
GO
CREATE INDEX in_mes_mmbe1_itemno ON mes_mmbe1( itemno  )
CREATE INDEX in_mes_mmbe1_compno ON mes_mmbe1( compno  )
GO
