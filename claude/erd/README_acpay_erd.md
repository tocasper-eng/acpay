<mission>
請對特定資料表建立 erp 關聯圖, 
輸出的格式是 html 
</mission>



<database>
	sql server:163.17.141.61,8081
	id:casper
	pwd:CasChrAliJimJam
	database:acpay
</database>

<database_object>
<erd>
以下的 t-sql 語法，只是要清楚表達資料表之間的關係，不必至實體資料庫建立 FOREIGN key . 


ALTER TABLE eep_trd ADD CONSTRAINT FK_eep_trd_eep_trh FOREIGN KEY (trno) REFERENCES eep_trh(trno);
ALTER TABLE eep_tod ADD CONSTRAINT FK_eep_tod_eep_toh FOREIGN KEY (tono) REFERENCES eep_toh(tono);
ALTER TABLE eep_tdd ADD CONSTRAINT FK_eep_tdd_eep_trh FOREIGN KEY (tdno) REFERENCES eep_tdh(tdno);

ALTER TABLE eep_plant ADD CONSTRAINT FK_eep_plant_eep_compno FOREIGN KEY (compno)  REFERENCES eep_comp(compno);
ALTER TABLE eep_ware  ADD CONSTRAINT FK_eep_ware_eep_plant   FOREIGN KEY (plantno) REFERENCES eep_plant(plantno);
ALTER TABLE eep_posi  ADD CONSTRAINT FK_eep_posi_eep_ware    FOREIGN KEY (compno)  REFERENCES eep_ware(wareno);

ALTER TABLE eep_itio ADD CONSTRAINT FK_eep_itio_eep_item     FOREIGN KEY (itemno)  REFERENCES eep_item(itemno);
ALTER TABLE eep_itio ADD CONSTRAINT FK_eep_itio_eep_ware     FOREIGN KEY (wareno)  REFERENCES eep_ware(wareno);
 

</erd>

</database_object>

<github repo>
tocasper-eng\gemio_wms_erd
tocasper@g.ncu.edu.tw 
</github repo>

<須遵守行為>
	每次任務完成都要更本專案的
	CLAUDE.md , SKILL.md 
	github tocasper-eng\gemio_wms_erd 
	
</須遵守行為>


