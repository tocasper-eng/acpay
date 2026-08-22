<mission>
寫一支後端程序，能夠將 source sql server的指定資料表 同步到 target 資料庫。 
</mission>


<source database="">
	sql server:192.168.50.7
	id:drlee
	pwd:ACpos#1234
	database:ACTtest
</source database>

<target database="">
	sql server:192.168.50.53,8001
	id:drlee
	pwd:ACpos#1234
	database:actest
</target database>

<description>
每次執行程序時，就要比對 source 與 target ，
都單向的由 source 寫入 target

資料表：
INVMA
INVMB
PURTG
PURTH
PURTI
PURTJ

</description>
 



<須遵守行為>
每次任務完成都要更新CLAUDE.md , SKILL.md 並上傳 github
</須遵守行為>

 
 