--USE [gemio_wms]
--GO
truncate table TBLDEF 
GO
--select * from tbldef 

insert into [TBLDEF](dbname,systno,menunum,
childTable,childTableDesc,childkeys,hasparent,reltype,parentTable,parentTableDesc,parentkeys) values
('acpay','WMS','62K','eep_trd'      ,'繳庫明細','trno'            ,'Y','T','eep_trh'   ,'繳庫主檔','trno'            ),
('acpay','WMS','62J','eep_tod'      ,'領料明細','tono'            ,'Y','T','eep_toh'   ,'領料主檔','tono'            ),
('acpay','WMS','66D','eep_tdd'      ,'調撥明細','tdno'            ,'Y','T','eep_tdh'   ,'調撥主檔','tdno'            ),
('acpay','WMS','62K','eep_plant'    ,'工廠代碼','compno'          ,'Y','T','eep_comp'  ,'公司代碼','compno'          ),
('acpay','WMS','96A','eep_ware'     ,'倉庫代碼','plantno'         ,'Y','T','eep_plant' ,'工廠代碼','plantno'         ),
('acpay','WMS','96A','eep_ware_empl','倉管人員','wareno'          ,'Y','T','eep_ware'  ,'倉庫代碼','wareno'         ),
('acpay','WMS','96A','eep_posi'     ,'儲位代碼','wareno'          ,'Y','T','eep_ware'  ,'倉庫代碼','wareno'          ),
('acpay','WMS','67Q','mes_itio'     ,'庫存異動','itemno'          ,'Y','T','eep_item'  ,'物料主檔','itemno'          ),
('acpay','WMS','67Q','mes_itio'     ,'庫存異動','wareno'          ,'Y','T','eep_ware'  ,'倉庫代碼','wareno'          ),
('acpay','WMS','96D','eep_item'     ,'物料主檔','clasno'          ,'Y','T','eep_clas'  ,'物料類型','clasno'          ),
('acpay','HR' ,'93A','eep_empl'     ,'員工主檔','depano'          ,'Y','T','eep_depa'  ,'部門代碼','depano'          ),
('acpay','HR' ,'93A','eep_empl'     ,'員工主檔','linenum'          ,'Y','T','eep_line'  ,'班組代碼','linenum'          ),
('acpay','CS','A01','eep_iwd_10'    ,'服務內容','契約編號'        ,'Y','T','eep_iwh'   ,'客服通知','契約編號'        ),
('acpay','CS','A01','eep_iwd_20'    ,'完工回報','契約編號'        ,'Y','T','eep_iwh'   ,'客服通知','契約編號'        ),
('acpay','CS','A01','eep_iwd_10'    ,'補充說明','契約編號'        ,'Y','T','eep_iwh'   ,'客服通知','契約編號'        ),
('acpay','CS','B01','pos_tod'       ,'設備清單','契約編號'        ,'Y','T','eep_iwh'   ,'外派工單','契約編號'        ),
('acpay','CS','C01','pos_tod'       ,'設備清單','契約編號'        ,'Y','T','eep_pos'   ,'新案追蹤','契約編號'        ),
('acpay','CS','D01','eep_d01'       ,'連鎖客戶','連鎖性客戶編號'  ,'Y','T','pos'       ,'新案追蹤','連鎖性客戶編號'  ),
('acpay','CS','E01','pos_tod'       ,'設備清單','契約編號'        ,'Y','T','pos_log'   ,'契約變更','契約編號'        ),
('acpay','CS','F01','pos_tod'       ,'設備清單','契約編號'        ,'Y','T','eep_dac'   ,'解約建檔','契約編號'        ),
('acpay','IS','91H','eep_numh'      ,'欄位名稱','menunum'         ,'Y','T','eep_menu'  ,'解約建檔','menunum'         ),
('acpay','IS','91I','eep_num8'      ,'欄位內容','menunum,fieldno' ,'Y','T','eep_numh'  ,'欄位名稱','menunum,fieldno' ),
('acpay','IS','61A','eep_bmd'       ,'組合子檔','bmno'            ,'Y','T','eep_bmh'   ,'組合主檔','bmno'            ),
('acpay','IS','61A','系統別'        ,'系統別'  ,'系統別代號'      ,'Y','T','eep_bmh'   ,'組合主檔','系統別代號'      ),
('acpay','IS','99B','usergroups'    ,'用戶群組'  ,'userid'        ,'Y','T','users'     ,'用戶代碼','userid'          ),
('acpay','IS','99B','usergroups'    ,'用戶群組'  ,'groupid'       ,'Y','T','groups'    ,'群組代碼','groupid'         ),
('acpay','ORG','91A','eep_depa'     ,'部門代碼'  ,'compno'        ,'Y','T','eep_comp'  ,'公司代碼','compno'         ),
('acpay','ORG','91A','eep_depa'     ,'部門代碼'  ,'group2'        ,'Y','T','eep_group2','利潤中心','group2'         ),
('acpay','ORG','95H','eep_plant'    ,'工廠代碼'  ,'compno'        ,'Y','T','eep_comp'  ,'公司代碼','compno'         ),
('acpay','ORG','94P','eep_sdgrp'    ,'銷售群組'  ,'sdorg'         ,'Y','T','eep_sdorg' ,'銷售組織','sdorg'         ),
('acpay','ORG','95P','eep_mmgrp'    ,'採購群組'  ,'mmorg'         ,'Y','T','eep_mmorg' ,'採購組織','mmorg'         ),
('acpay','AR','48E','vw_POS_CRM_ACRTB'   ,'結帳單子','TB001,TB002' ,'Y','T',
                    'vw_POS_CRM_ACRTA'   ,'結帳單主','TA001,TA002' ),	   
('acpay','AR','48F','vw_POS_CRM_ACRTD'   ,'收款單子','TD001,TD002' ,'Y','T',
       'vw_POS_CRM_ACRTC'   ,'收款單主','TC001,TC002' ) 
 