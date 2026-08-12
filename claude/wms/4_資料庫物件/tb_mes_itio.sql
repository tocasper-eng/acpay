--USE [gemio_wms]
--GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mes_itio]') AND type in (N'U'))
   DROP TABLE [dbo].[mes_itio]
GO
CREATE TABLE [dbo].[mes_itio](
iono     nvarchar(20)  NOT NULL,--異動單據
ioseq    char(04)      NOT NULL,--項次
ioseqseq char(04)      NOT NULL,--三序
iodate   char(08)      NOT NULL,--異動日期
itemno   nvarchar(40)  not NULL,--物料編號
compno   nvarchar(40)      NULL,--公司代碼
plantno  nvarchar(40)      NULL,--工廠代碼
wareno   nvarchar(40)      NULL,--倉庫代碼
posino   nvarchar(40)  not NULL,--儲存格位
ioqty    decimal(20,2) not NULL,--異動數量
constraint pk_mes_itio_iono_ioseq primary key ( iono,ioseq,ioseqseq)
)
GO
CREATE INDEX in_mes_itio_itemno  ON mes_itio( itemno  )
CREATE INDEX in_mes_itio_posino  ON mes_itio( posino  )
CREATE INDEX in_mes_itio_iodate  ON mes_itio( iodate  )
GO
