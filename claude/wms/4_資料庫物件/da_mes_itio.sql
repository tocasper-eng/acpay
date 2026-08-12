USE [gemio_wms]
GO
insert into mes_itio(iono,ioseq,ioseqseq,iodate,itemno,posino,wareno,plantno,compno,ioqty)
values ('20260501',1,1,'20260501','itemno-1','a-b-c-1','a-b-c','a-b','a',10)
 
insert into mes_itio(iono,ioseq,ioseqseq,iodate,itemno,posino,wareno,plantno,compno,ioqty)
values ('20260506',2,1,'20260506','itemno-1','a-b-c-1','a-b-c','a-b','a',-2)
 
insert into mes_itio(iono,ioseq,ioseqseq,iodate,itemno,posino,wareno,plantno,compno,ioqty)
values ('20260502',2,1,'20260502','itemno-1','a-b-c-1','a-b-c','a-b','a',-1)
 

insert into mes_itio(iono,ioseq,ioseqseq,iodate,itemno,posino,wareno,plantno,compno,ioqty)
values ('20260202',2,1,'20260502','itemno-2','a-b-c-1','a-b-c','a-b','a',21)
 


select * from mes_itio 
select * from mes_itea4 
select * from mes_itea3 
select * from mes_itea2 
select * from mes_itea1 
