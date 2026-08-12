<mission>
寫一套 ERP 將後端 sql server 極大化，
前端開發極少化。
能用 T-SQL 相關物件解決的，就絕不用前端處理。 
</mission>

<description>
當 mes_itio 發生變化時，即時更新
mes_itea1 
mes_itea2 
mes_itea3 
mes_itea4
要注意，mes_itio 
1 可能更改日期，例如 2026/05/06 改成2026/04/30
2 可能被刪除。
3 可改更改 posino , itemno 
</description>

<database>
sql server:163.17.141.61,8081 
database :gemio_wms 
id:casper
pwd:CasChrAliJimJam
</database>

<database_object>
tb_mes_itio :所有的庫存異動單據
tb_mes_level:庫存層級共四個層級
tb_mes_itea1:庫存層一的日結餘額
tb_mes_itea2:庫存層二的日結餘額
tb_mes_itea3:庫存層三的日結餘額
tb_mes_itea4:庫存層四的日結餘額
</database_object>

<須遵守行為>
每次任務完成都要更新CLAUDE.md , SKILL.md 並上傳 github
</須遵守行為>

<被限制行為>
資料表的內容，除了這六個之外，其餘不要更動

tb_mes_itio :所有的庫存異動單據
tb_mes_level:庫存層級共四個層級
tb_mes_itea1:庫存層一的日結餘額
tb_mes_itea2:庫存層二的日結餘額
tb_mes_itea3:庫存層三的日結餘額
tb_mes_itea4:庫存層四的日結餘額
</被限制行為>

<7_reference_docs_image>
這個資料夾，若有內容，都是供您參考的。
</7_reference_docs_image>

<github repo>
tocasper-eng\gemio_wms
tocasper@g.ncu.edu.tw 
</github repo>

<驗証準則>
在四個層級 
mes_itea1
mes_itea2
mes_itea3
mes_itea4
compno , plantno , wareno , posino 都要符合
期初數量 + 本期入庫 - 本期出庫 = 期末數量
</驗証準則>