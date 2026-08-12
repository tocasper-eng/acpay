--USE [gemio_wms]
--GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mes_itea4]') AND type in (N'U'))
    DROP TABLE [dbo].[mes_itea4]
GO
CREATE TABLE [dbo].[mes_itea4](
	[iodate] [char](08)                NOT NULL,--異動日期
	[itemno] [nvarchar](40)            NOT NULL,--物料編號
	[posino] [nvarchar](40)            NOT NULL,--儲位代碼
	[OpeningQuantity]  [decimal](18,2) NOT NULL,--期初數量
	[InboundQuantity]  [decimal](18,2) NOT NULL,--本期入庫
	[OutboundQuantity] [decimal](18,2) NOT NULL,--本期出庫
	[ClosingQuantity]  [decimal](18,2) NOT NULL --期末數量
constraint pk_mes_itea4  primary key ( iodate,itemno,posino)
)
GO
CREATE INDEX in_mes_itea4_posino ON mes_itea4( posino  )
CREATE INDEX in_mes_itea4_itemno ON mes_itea4( itemno  )
GO
