--USE [casper]
--GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stka_clitea]') AND type in (N'U'))
    DROP TABLE stka_clitea
GO
--庫存日結關帳日
CREATE TABLE [dbo].[stka_clitea](
[num] [bigint] IDENTITY(1,1)     NOT NULL,--主流水號
cldate         char(08)              null,--關帳日期
dt             datetime              NULL,--日期時間
chjernoi nvarchar(48),
chjernou nvarchar(48)
constraint pk_stka_clitea2_num  primary key ( num )  
)
GO 
CREATE INDEX in_stka_clitea_datec  ON stka_clitea( cldate )
GO
 