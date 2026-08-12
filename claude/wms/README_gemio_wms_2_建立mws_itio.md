<mission>

寫三支 trigger 

是三個前端tod出庫，trd入庫，tdd調撥的單據要寫入 mes_itio 

tr_111_eep_tod_mes_itio on eep_tod 
tr_111_eep_trd_mes_itio on eep_trd 
tr_111_eep_tdd_mes_itio on eep_tdd 

新增，更改，刪除，都要處理。

若來源表無 posino   , 
    就讓 mes_itio.posino  =  mes_itio.wareno 

若來源表無 wareno  , 
    就提示錯誤。 

若來源表無 plantno  
   先至 select plantno from eep_ware where wareno=@wareno 
   若仍無，就讓 mes_itio.plantno =  mes_itio.wareno

若來源表無 compno   
   先至 select compno from eep_plant where plantno=@plantno  
   若仍無，就讓 mes_itio.compno  =  '公司代碼'
 
</mission>
 