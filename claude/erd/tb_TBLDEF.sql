--USE [gemio_wms]
--GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBLDEF]') AND type in (N'U'))
    DROP TABLE [dbo].[TBLDEF]
GO
CREATE TABLE [dbo].[TBLDEF](
num bigint identity(1,1)        not null,--主流水號
dbname           nvarchar(20)   NOT NULL,--資料庫
systno           nvarchar(20)   not null,--模組
menunum          nvarchar(03)   NOT NULL,--功能代碼
childTable       nvarchar(40)   NOT NULL,--子資料表
childTableDesc   nvarchar(40)   NOT NULL,--子資料表名稱
childkeys        nvarchar(40)       NULL,--子資料表鍵值
hasparent        char(01)           null,--有父階嗎
reltype          char(01)           null,--關聯模式 T 資料表，P 程序
parentTable      nvarchar(40)       NULL,--主資料表
parentTableDesc  nvarchar(40)       NULL,--主資料表名稱
parentkeys       nvarchar(40)       NULL,--主資料表鍵值
constraint pk_TBLDEF_num primary key ( num )
)
GO
CREATE INDEX in_TBLDEF_menunum     ON TBLDEF( menunum       )
CREATE INDEX in_TBLDEF_childTable  ON TBLDEF( childTable    )
CREATE INDEX in_TBLDEF_parentTable ON TBLDEF( parentTable   )

GO
