<mission>
寫一套 ERP 將後端 sql server 極大化，
前端開發極少化。
能用 T-SQL 相關物件解決的，就絕不用前端處理。 



</mission>

<description>
	當 mes_itio 發生變化時，即時更新
	mes_itea1  compno  公司代碼層級
	mes_itea2  plantno 工廠代碼層級
	mes_itea3  wareno  倉庫代碼層級
	mes_itea4  posino   儲位代碼層級
	要注意，mes_itio
	1 可能更改日期，例如 2026/05/06 改成2026/04/30
	2 可能被刪除。
	3 可改更改 posino , itemno

	然後再將最後一次的異動日期的結果寫入
	mes_mmbe1 compno  公司代碼層級
	mes_mmbe2 plantno 工廠代碼層級
	mes_mmbe3 wareno  倉庫代碼層級
	mes_mmbe4 posino   儲位代碼層級
	
	1. mes_itio 的數量欄位會用單一欄位若是出庫會加上 負號  - 號。
	2. mes_itea 不必保留「當天無異動」的日期列。
	3. mes_mmbe* 的 key 只有 (itemno, 階層碼)。
	4. eep_posi 若無就帶入 eep_ware , 長度都是 40 位。
	5. 階層對不上時，例如 無posino就讓 posino=wareno 。
</description>
 

<database>
sql server:163.17.141.61,8081
id:casper
pwd:CasChrAliJimJam
database:acpay
</database>

<database_object>
	<trigger>

		若下列資料庫物料 trigger ，不存在，請列示出來。
		tr_011_eep_tdd_mes_itio on eep_tdd
		tr_100_66d_10_eep_tdd
		tr_010_66d_00_timer_eep
		tr_100_66d_00_eep_tdh

		tr_011_eep_tod_mes_itio on eep_tod
		tr_100_62j_10_eep_tod
		tr_010_62j_00_timer_eep
		tr_100_62j_00_eep_toh

		tr_011_eep_trd_mes_itio on eep_trd
		tr_100_62k_10_eep_trd
		tr_010_62k_00_timer_eep
		tr_100_62k_00_eep_trh

		tr_011_pos_tod_mes_itio on pos_tod

		tr_mes_itio_sync on mes_itio
		</trigger>
	</database_object>

<須遵守行為>
每次任務完成都要更新CLAUDE.md , SKILL.md 並上傳 github
</須遵守行為>

 
 