<mission>
請對特定資料表建立 erp 關聯圖。
</mission>

<desccription>

	輸出的格式是 html ,

	資料表的關聯關係請直接讀資料表 TBLDEF。
	左邊的導航欄，請用 TBLDEF.menunum 當我點擊時，右邊的主頁才出現該 ER關聯圖
	有出現在 ERD 的才畫出來。

	insert into [TBLDEF](menunum,
	childTable,childTableDesc,childkeys,hasparent,parentTable,parentTableDesc,parentkeys) values
	('62K','eep_trd'    ,'繳庫明細','trno'            ,'Y','eep_trh'   ,'繳庫主檔','trno'            ),
	('62J','eep_tod'    ,'領料明細','tono'            ,'Y','eep_toh'   ,'領料主檔','tono'            ),
	('66D','eep_tdd'    ,'調撥明細','tdno'            ,'Y','eep_tdh'   ,'調撥主檔','tdno'            ),
	('62K','eep_plant'  ,'工廠代碼','compno'          ,'Y','eep_comp'  ,'公司代碼','compno'          ),
	('96A','eep_ware'   ,'倉庫代碼','plantno'         ,'Y','eep_plant' ,'工廠代碼','plantno'         ),
	('96A','eep_posi'   ,'儲位代碼','wareno'          ,'Y','eep_ware'  ,'倉庫代碼','wareno'          ),
	('67Q','mes_itio'   ,'庫存異動','itemno'          ,'Y','eep_item'  ,'物料主檔','itemno'          ),
	('67Q','mes_itio'   ,'庫存異動','wareno'          ,'Y','eep_ware'  ,'倉庫代碼','wareno'          ),
	('A01','eep_iwd_10' ,'服務內容','契約編號'        ,'Y','eep_iwh'   ,'客服通知','契約編號'        ),
	('A01','eep_iwd_20' ,'完工回報','契約編號'        ,'Y','eep_iwh'   ,'客服通知','契約編號'        ),
	('A01','eep_iwd_10' ,'補充說明','契約編號'        ,'Y','eep_iwh'   ,'客服通知','契約編號'        ),
	('B01','pos_tod'    ,'設備清單','契約編號'        ,'Y','eep_iwh'   ,'外派工單','契約編號'        ),
	('C01','pos_tod'    ,'設備清單','契約編號'        ,'Y','eep_pos'   ,'新案追蹤','契約編號'        ),
	('D01','eep_d01'    ,'連鎖客戶','連鎖性客戶編號'  ,'Y','pos'       ,'新案追蹤','連鎖性客戶編號'  ),
	('E01','pos_tod'    ,'設備清單','契約編號'        ,'Y','pos_log'   ,'契約變更','契約編號'        ),
	('F01','pos_tod'    ,'設備清單','契約編號'        ,'Y','eep_dac'   ,'解約建檔','契約編號'        ),
	('91H','eep_numh'   ,'欄位名稱','menunum'         ,'Y','eep_menu'  ,'解約建檔','menunum'         ),
	('91I','eep_num8'   ,'欄位內容','menunum,fieldno' ,'Y','eep_numh'  ,'欄位名稱','menunum,fieldno' )

舉例若點選  67Q ，才出現 mes_itio , eep_item , eep_ware 的關聯圖

</desccription>


<database>
	sql server:163.17.141.61,8081
	id:casper
	pwd:CasChrAliJimJam
	database:acpay
</database>

 
<github repo>
	tocasper-eng\gemio_wms_erd
	tocasper@g.ncu.edu.tw
</github repo>

<須遵守行為>
	每次任務完成都要更本專案的
	CLAUDE.md , SKILL.md 
	github tocasper-eng\gemio_wms_erd 
	
</須遵守行為>


