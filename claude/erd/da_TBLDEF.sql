--USE [gemio_wms]
--GO
truncate table TBLDEF 
GO
--select * from tbldef 

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

 