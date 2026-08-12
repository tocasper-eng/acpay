 
--USE [casper]
--GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[itio]') AND type in (N'U'))
    DROP TABLE itio 
GO
--庫存日結關帳日
CREATE TABLE [dbo].[itio]( 
	[iodate]   [char](08)     NOT NULL,
	[iono]     [char](10)     NOT NULL,
	[ioseq]    [char](04)     NOT NULL,
	[ioseqseq] [char](01)     NOT NULL, 
	[itemno]   [char](20)     NOT NULL, 
	[wareno]   [char](8)      NOT NULL,
	[posino]   [char](8)      NOT NULL,
	[alocno]   [nvarchar](30) NOT NULL,
	[wareswt]  [nvarchar](30) NOT NULL,
	tmp        char(01)           null,
 	[qty]    [decimal](24, 8)   NULL
constraint pk_itio_clitea2_num  primary key ( iono, ioseq, ioseqseq)  
)
GO 
CREATE INDEX in_itio_iodate  ON itio( iodate )
CREATE INDEX in_itio_itemno  ON itio( itemno )
GO
 