--USE [casper]
--GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stka_itea]') AND type in (N'U'))
    DROP TABLE stka_itea
GO
CREATE TABLE stka_itea(
iodate     char(08)          not NULL,--
itemno     nvarchar(20)      not NULL,--
wareno     char(08)          not NULL,--

[OpeningQuantity]  [decimal](18, 3) NOT NULL,
[InboundQuantity]  [decimal](18, 3) NOT NULL,
[OutboundQuantity] [decimal](18, 3) NOT NULL,
[ClosingQuantity]  [decimal](18, 3) NOT NULL,
num  bigint identity(1,1)    not null
constraint pk_stka_itea_num  primary key ( num )  
)
GO 
CREATE INDEX in_stka_itea_itemno  ON stka_itea ( itemno  )
CREATE INDEX in_stka_itea_iodate  ON stka_itea ( iodate  )
CREATE INDEX in_stka_itea_wareno  ON stka_itea ( wareno  )

--CREATE INDEX in_stka_itea_wareswt ON stka_itea ( wareswt )
--CREATE INDEX in_stka_itea_alocno  ON stka_itea ( alocno )
GO						   						  


--use chjer
--go
--IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='stka_itea')
--   DROP VIEW stka_itea
--GO
--CREATE VIEW stka_itea as select * from casper.dbo.stka_itea
--go
