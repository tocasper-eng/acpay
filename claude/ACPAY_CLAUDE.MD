<資料庫資訊>

   <客服資料庫>
   sql server:192.168.50.53,8000 
   id:drlee
   pwd:ACpos#1234
   database:acpay
   </客服資料庫>



   <庫存資料庫>

   sql server:192.168.50.53,8001 
   id:drlee
   pwd:ACpos#1234
   database:casper
   </庫存資料庫>


   <應收資料庫>
   sql server:192.168.50.7
   id:drlee
   pwd:ACpos#1234
   database:AC
   </應收資料庫>
</資料庫資訊>
 
 
<COLLATE>
一律選擇 Chinese_Taiwan_Stroke_CI_AS
</COLLATE>

<注意事項>
匯入欄位共有：itemna,itemno,itemnm,clasnm,remark

特殊欄位 clasno 
eep_item.clasno = select clasno from clas where clasnm=eep_item.clasnm 

key field:itemno , 若已經存在，就覆蓋其他欄位
</注意事項>

<ForeignKey>
eep_clas=clasno = eep_item.clasno 


</ForeignKey>

<收尾工作>
系統目錄 C:\Users\drlee\Nutstore\1\Obsidian\EEP\35_ACPAY\claude

專案目錄 C:\Users\drlee\Nutstore\1\Obsidian\EEP\35_ACPAY\claude\....

更新 CLAUDE.MD  SKILL.MD 
</收尾工作>


 



