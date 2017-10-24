select 
im.DEPT
,su.SUPPLIER ||' '||su.SUP_NAME as sup_name
,im.class
,im.subclass
,ril.item
,im.ITEM_PARENT
,ril.PRIMARY_PACK_NO
,ril.PRIMARY_PACK_QTY
,im.ITEM_DESC
,ril.location
,DECODE(RIL.REVIEW_CYCLE,'0','WEEKLY','1','DAILY','2','2_WEEKS','4','4_WEEKS') REVIEW_CYCLE
,ril.stock_cat
,ril.repl_order_ctrl
,ril.source_wh
,to_char(ril.activate_date, 'dd-mon-yyyy')
,to_char(ril.deactivate_date, 'dd-mon-yyyy')
,ril.pres_stock, ril.demo_stock
,ril.repl_method
,ril.min_stock
,ril.max_stock
,ril.INCR_PCT
,ril.pickup_lead_time
,ril.wh_lead_time
,trunc(ril.last_review_date)
,ril.next_review_date
,ril.adj_pickup_lead_time
,ril.adj_supp_lead_time
,ril.last_roq
,ril.supp_lead_time
,ril.inner_pack_size
,ril.supp_pack_size
,ril.MIN_SUPPLY_DAYS Min_Days
,ril.MAX_SUPPLY_DAYS Max_Days
,ril.ROUND_LVL, trunc(sysdate)
from repl_item_loc ril
,sups su
,item_master im
,deps
where ril.item = im.item
and im.dept = deps.dept
--  and ril.loc_type = 'S'
and ril.primary_repl_supplier = su.supplier(+)
and ACTIVATE_DATE < SYSDATE + 180
and (DEACTIVATE_DATE IS not NULL and DEACTIVATE_DATE > SYSDATE -180)
and ril.dept = '961'
and rownum <= '100';