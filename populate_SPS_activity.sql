truncate table SPS_ACTIVITY_STAGING;

insert into SPS_ACTIVITY_STAGING
(Q_WK_ID, Q_SKU_ID, Q_STR_ID, Sku, Location, Selling_Unit_Retl,
Sales_U_Gross, Sales_RDLRS_Gross, Sales_U_Net, Sales_RDLRS_Net, Cogs_CDLRS_x, GM_CDLRS,
Inv_U, Inv_CDLRS, Inv_RDLRS, Cust_Returns_U, Curr_OO_U, Curr_OO_CDLRS, Curr_OO_RDLRS,
Recvd_U, Recvd_CDLRS, Recvd_RDLRS, Inv_IT_U, Inv_IT_CDLRS, Inv_IT_RDLRS, RTV_U,
Net_Inv_Adj_U, Promo_Mkdn_RDLRS, Clrn_Mkdn_RDLRS, Reg_Mkdn_RDLRS, Total_Mkdn_RDLRS_Str,
max_Avg_Cost
)
select x.Q_WK_ID, x.Q_SKU_ID, x.Q_STR_ID, x.Sku, Location, --  sku.Q_SKU_DISPLAY,
itloc.Q_INV_SELLING_UNT_RETL    Selling_Unit_Retl,
 sum(x.Sales_U_Gross)      Sales_U_Gross,
 sum(x.Sales_RDLRS_Gross)  Sales_RDLRS_Gross,
 sum(x.Sales_U_Net)        Sales_U_Net,
 sum(x.Sales_RDLRS_Net)    Sales_RDLRS_Net,
 sum(x.Cogs_CDLRS_x)       Cogs_CDLRS_x,
 sum(x.GM_CDLRS)           GM_CDLRS,
 sum(x.Inv_U)              Inv_U,
 sum(x.Inv_CDLRS)          Inv_CDLRS,
 sum(x.Inv_RDLRS)          Inv_RDLRS,
 sum(x.Cust_Returns_U)     Cust_Returns_U,
 sum(x.Curr_OO_U)          Curr_OO_U,
 sum(x.Curr_OO_CDLRS)      Curr_OO_CDLRS,
 sum(x.Curr_OO_RDLRS)      Curr_OO_RDLRS,
 sum(x.Recvd_U)            Recvd_U,
 sum(x.Recvd_CDLRS)        Recvd_CDLRS,
 sum(x.Recvd_RDLRS)        Recvd_RDLRS,
 sum(x.Inv_IT_U)           Inv_IT_U,
 sum(x.Inv_IT_CDLRS)       Inv_IT_CDLRS,
 sum(x.Inv_IT_RDLRS)       Inv_IT_RDLRS,
 sum(x.RTV_U)              RTV_U,
 sum(x.Net_Inv_Adj_U)      Net_Inv_Adj_U,
 sum(x.Promo_Mkdn_RDLRS)   Promo_Mkdn_RDLRS,
 sum(x.Clrn_Mkdn_RDLRS)    Clrn_Mkdn_RDLRS,
 sum(x.Reg_Mkdn_RDLRS)     Reg_Mkdn_RDLRS,
 sum(x.Total_Mkdn_RDLRS_Str)       Total_Mkdn_RDLRS_Str,
 sum(x.max_Avg_Cost)       max_Avg_Cost
From (
-- Sales, Returns and GM
select cal.Q_WK_ID Q_WK_ID, sls.Q_SKU_ID Q_SKU_ID, sls.Q_STR_ID Q_STR_ID,
   sku.Q_SKU_SNUM Sku, loc.Q_STR_DNUM Location, --  sku.Q_SKU_DISPLAY,
   sum(DECODE(sls.Q_SLS_RTRN_FLG, 0, sls.Q_SLS_UNTS, 0)) Sales_U_Gross,
   sum(DECODE(sls.Q_SLS_RTRN_FLG, 0, sls.Q_SLS_RDLRS, 0)) Sales_RDLRS_Gross,
   sum(sls.Q_SLS_UNTS) Sales_U_Net,
   sum(sls.Q_SLS_RDLRS) Sales_RDLRS_Net,
   sum(sls.Q_SLS_COGS_CDLRS) Cogs_CDLRS_x,
   (sum(sls.Q_SLS_RDLRS) - sum(sls.Q_SLS_COGS_CDLRS)) GM_CDLRS,
cast(NULL as numeric(12,4))  Inv_U,
cast(NULL as numeric(12,4))  Inv_CDLRS,
cast(NULL as numeric(12,4))  Inv_RDLRS,
   sum(DECODE(sls.Q_SLS_RTRN_FLG, 1, sls.Q_SLS_UNTS, 0)) Cust_Returns_U,
cast(NULL as numeric(12,4))  Curr_OO_U,
cast(NULL as numeric(12,4))  Curr_OO_CDLRS,
cast(NULL as numeric(12,4))  Curr_OO_RDLRS,
cast(NULL as numeric(12,4))  Recvd_U,
cast(NULL as numeric(12,4))  Recvd_CDLRS,
cast(NULL as numeric(12,4))  Recvd_RDLRS,
cast(NULL as numeric(12,4))  Inv_IT_U,
cast(NULL as numeric(12,4))  Inv_IT_CDLRS,
cast(NULL as numeric(12,4))  Inv_IT_RDLRS,
cast(NULL as numeric(12,4))  RTV_U,
cast(NULL as numeric(12,4))  Net_Inv_Adj_U,
cast(NULL as numeric(12,4))  Promo_Mkdn_RDLRS,
cast(NULL as numeric(12,4))  Clrn_Mkdn_RDLRS,
cast(NULL as numeric(12,4))  Reg_Mkdn_RDLRS,
cast(NULL as numeric(12,4))  Total_Mkdn_RDLRS_Str,
cast(NULL as numeric(12,4))  max_Avg_Cost
from Q_QF_SLS_SKU_STR_D_V sls
join Q_QL_PRD_SKU_V sku
  on (sls.Q_SKU_ID = sku.Q_SKU_ID)
join Q_QL_PRD_CLS_V cls
  on (sku.Q_CLS_ID = cls.Q_CLS_ID)
join Q_QL_LOC_STR_V loc
  on (sls.Q_STR_ID = loc.Q_STR_ID)
join Q_QL_CAL_DT_V cal
  on (sls.Q_DT_ID = cal.Q_DT_ID)
-- Option
join Q_QL_CAL_DT_V cal2
 on (cal.Q_WK_ID = cal2.Q_WK_LW or cal.Q_WK_ID = cal2.Q_WK_2WA)
where cal2.Q_DT_ID = current_date
-- Option replace --where cal.Q_WK_ID BETWEEN to_date('02/04/2017', 'mm/dd/yyyy') AND to_date('02/11/2017', 'mm/dd/yyyy')
and cls.GRP_IDNT between '201' and '270'
  and loc.CHAIN_KEY = 1
/* Put Test Data here
and (
 (sku.Q_SKU_SNUM in ('10657098') and loc.Q_STR_DNUM in ('164','10','9830'))
 or (sku.Q_SKU_SNUM in ('10385749') and loc.Q_STR_DNUM in ('164','10','9830','9840'))
 or (sku.Q_SKU_SNUM = '10422196' and loc.Q_STR_DNUM = '164')
)
 */
group by cal.Q_WK_ID, sls.Q_SKU_ID, sls.Q_STR_ID, sku.Q_SKU_SNUM, loc.Q_STR_DNUM -- ,sku.Q_SKU_DISPLAY
-- END - Sales, Returns and GM
UNION
-- INV and IT
select inv.Q_WK_ID Q_WK_ID, inv.Q_SKU_ID Q_SKU_ID, inv.Q_STR_ID Q_STR_ID,
   sku.Q_SKU_SNUM Sku, loc.Q_STR_DNUM Location, --  sku.Q_SKU_DISPLAY,
cast(NULL as numeric(12,4))  Sales_U_Gross,
cast(NULL as numeric(12,4))  Sales_RDLRS_Gross,
cast(NULL as numeric(12,4))  Sales_U_Net,
cast(NULL as numeric(12,4))  Sales_RDLRS_Net,
cast(NULL as numeric(12,4))  Cogs_CDLRS_x,
cast(NULL as numeric(12,4))  GM_CDLRS,
   sum(inv.Q_INV_OH_UNTS_EOP) Inv_U,
   sum(inv.Q_INV_OH_CDLRS_EOP) Inv_CDLRS,
   sum(inv.Q_INV_OH_RDLRS_EOP) Inv_RDLRS,
cast(NULL as numeric(12,4))  Cust_Returns_U,
cast(NULL as numeric(12,4))  Curr_OO_U,
cast(NULL as numeric(12,4))  Curr_OO_CDLRS,
cast(NULL as numeric(12,4))  Curr_OO_RDLRS,
cast(NULL as numeric(12,4))  Recvd_U,
cast(NULL as numeric(12,4))  Recvd_CDLRS,
cast(NULL as numeric(12,4))  Recvd_RDLRS,
   sum(inv.Q_INV_IT_UNTS_EOP) Inv_IT_U,
   sum(inv.Q_INV_IT_CDLRS_EOP) Inv_IT_CDLRS,
   sum(inv.Q_INV_IT_RDLRS_EOP) Inv_IT_RDLRS,
cast(NULL as numeric(12,4))  RTV_U,
cast(NULL as numeric(12,4))  Net_Inv_Adj_U,
cast(NULL as numeric(12,4))  Promo_Mkdn_RDLRS,
cast(NULL as numeric(12,4))  Clrn_Mkdn_RDLRS,
cast(NULL as numeric(12,4))  Reg_Mkdn_RDLRS,
cast(NULL as numeric(12,4))  Total_Mkdn_RDLRS_Str,
   max(inv.Q_INV_UNT_COST_EOP) max_Avg_Cost
from ADMIN.Q_QF_INV_SKU_STR_W_EOP_V inv
join Q_QL_PRD_SKU_V sku
  on (inv.Q_SKU_ID = sku.Q_SKU_ID)
join Q_QL_PRD_CLS_V cls
  on (sku.Q_CLS_ID = cls.Q_CLS_ID)
join Q_QL_LOC_STR_V loc
  on (inv.Q_STR_ID = loc.Q_STR_ID)
-- Option
join Q_QL_CAL_DT_V cal2
 on (inv.Q_WK_ID = cal2.Q_WK_LW or inv.Q_WK_ID = cal2.Q_WK_2WA)
where cal2.Q_DT_ID = current_date
-- Option replace --where inv.Q_WK_ID BETWEEN to_date('02/04/2017', 'mm/dd/yyyy') AND to_date('02/11/2017', 'mm/dd/yyyy')
  and cls.GRP_IDNT between '201' and '270'
  and loc.CHAIN_KEY = 1
/* Put Test Data here
*/
group by inv.Q_WK_ID, inv.Q_SKU_ID, inv.Q_STR_ID, sku.Q_SKU_SNUM, loc.Q_STR_DNUM -- ,sku.Q_SKU_DISPLAY
-- END - INV and IT
UNION
-- Mkdns
select cal.Q_WK_ID Q_WK_ID, mkdn.Q_SKU_ID Q_SKU_ID, mkdn.Q_STR_ID Q_STR_ID,
   sku.Q_SKU_SNUM Sku, loc.Q_STR_DNUM Location, --  sku.Q_SKU_DISPLAY,
cast(NULL as numeric(12,4))  Sales_U_Gross,
cast(NULL as numeric(12,4))  Sales_RDLRS_Gross,
cast(NULL as numeric(12,4))  Sales_U_Net,
cast(NULL as numeric(12,4))  Sales_RDLRS_Net,
cast(NULL as numeric(12,4))  Cogs_CDLRS_x,
cast(NULL as numeric(12,4))  GM_CDLRS,
cast(NULL as numeric(12,4))  Inv_U,
cast(NULL as numeric(12,4))  Inv_CDLRS,
cast(NULL as numeric(12,4))  Inv_RDLRS,
cast(NULL as numeric(12,4))  Cust_Returns_U,
cast(NULL as numeric(12,4))  Curr_OO_U,
cast(NULL as numeric(12,4))  Curr_OO_CDLRS,
cast(NULL as numeric(12,4))  Curr_OO_RDLRS,
cast(NULL as numeric(12,4))  Recvd_U,
cast(NULL as numeric(12,4))  Recvd_CDLRS,
cast(NULL as numeric(12,4))  Recvd_RDLRS,
cast(NULL as numeric(12,4))  Inv_IT_U,
cast(NULL as numeric(12,4))  Inv_IT_CDLRS,
cast(NULL as numeric(12,4))  Inv_IT_RDLRS,
cast(NULL as numeric(12,4))  RTV_U,
cast(NULL as numeric(12,4))  Net_Inv_Adj_U,
   sum(mkdn.PROMO_MKDN_AMT) Promo_Mkdn_RDLRS,
   sum(mkdn.CLRN_MKDN_AMT) Clrn_Mkdn_RDLRS,
   sum(mkdn.REG_MKDN_AMT) Reg_Mkdn_RDLRS,
   ((sum(mkdn.CLRN_MKDN_AMT) + sum(mkdn.PROMO_MKDN_AMT)) + sum(mkdn.REG_MKDN_AMT)) Total_Mkdn_RDLRS_Str,
cast(NULL as numeric(12,4))  max_Avg_Cost
from ADMIN.Q_PL_RDW_SLS_MKDN_ITEM_LD_DM mkdn
join Q_QL_PRD_SKU_V sku
  on (mkdn.Q_SKU_ID = sku.Q_SKU_ID)
join Q_QL_PRD_CLS_V cls
  on (sku.Q_CLS_ID = cls.Q_CLS_ID)
join Q_QL_LOC_STR_V loc
  on (mkdn.Q_STR_ID = loc.Q_STR_ID)
join Q_QL_CAL_DT_V cal
  on (mkdn.Q_DT_ID = cal.Q_DT_ID)
-- Option
join Q_QL_CAL_DT_V cal2
 on (cal.Q_WK_ID = cal2.Q_WK_LW or cal.Q_WK_ID = cal2.Q_WK_2WA)
where cal2.Q_DT_ID = current_date
-- Option replace --where cal.Q_WK_ID BETWEEN to_date('02/04/2017', 'mm/dd/yyyy') AND to_date('02/11/2017', 'mm/dd/yyyy')
  and cls.GRP_IDNT between '201' and '270'
  and loc.CHAIN_KEY = 1
  and loc.Q_STR_DC_FLG in (0)
/* Test Data
*/
group by cal.Q_WK_ID, mkdn.Q_SKU_ID, mkdn.Q_STR_ID, sku.Q_SKU_SNUM, loc.Q_STR_DNUM -- ,sku.Q_SKU_DISPLAY
-- END - Mkdn
UNION
-- RTV
select cal.Q_WK_ID Q_WK_ID, rtv.Q_SKU_ID Q_SKU_ID, rtv.Q_STR_ID Q_STR_ID,
   sku.Q_SKU_SNUM Sku, loc.Q_STR_DNUM Location, --  sku.Q_SKU_DISPLAY,
cast(NULL as numeric(12,4))  Sales_U_Gross,
cast(NULL as numeric(12,4))  Sales_RDLRS_Gross,
cast(NULL as numeric(12,4))  Sales_U_Net,
cast(NULL as numeric(12,4))  Sales_RDLRS_Net,
cast(NULL as numeric(12,4))  Cogs_CDLRS_x,
cast(NULL as numeric(12,4))  GM_CDLRS,
cast(NULL as numeric(12,4))  Inv_U,
cast(NULL as numeric(12,4))  Inv_CDLRS,
cast(NULL as numeric(12,4))  Inv_RDLRS,
cast(NULL as numeric(12,4))  Cust_Returns_U,
cast(NULL as numeric(12,4))  Curr_OO_U,
cast(NULL as numeric(12,4))  Curr_OO_CDLRS,
cast(NULL as numeric(12,4))  Curr_OO_RDLRS,
cast(NULL as numeric(12,4))  Recvd_U,
cast(NULL as numeric(12,4))  Recvd_CDLRS,
cast(NULL as numeric(12,4))  Recvd_RDLRS,
cast(NULL as numeric(12,4))  Inv_IT_U,
cast(NULL as numeric(12,4))  Inv_IT_CDLRS,
cast(NULL as numeric(12,4))  Inv_IT_RDLRS,
   sum(rtv.Q_RTV_UNTS) RTV_U,
cast(NULL as numeric(12,4))  Net_Inv_Adj_U,
cast(NULL as numeric(12,4))  Promo_Mkdn_RDLRS,
cast(NULL as numeric(12,4))  Clrn_Mkdn_RDLRS,
cast(NULL as numeric(12,4))  Reg_Mkdn_RDLRS,
cast(NULL as numeric(12,4))  Total_Mkdn_RDLRS_Str,
cast(NULL as numeric(12,4))  max_Avg_Cost
from ADMIN.Q_QF_PO_RTV_V rtv
join Q_QL_PRD_SKU_V sku
  on (rtv.Q_SKU_ID = sku.Q_SKU_ID)
join Q_QL_PRD_CLS_V cls
  on (sku.Q_CLS_ID = cls.Q_CLS_ID)
join Q_QL_LOC_STR_V loc
  on (rtv.Q_STR_ID = loc.Q_STR_ID)
join Q_QL_CAL_DT_V cal
  on (rtv.Q_DT_ID = cal.Q_DT_ID)
-- Option
join Q_QL_CAL_DT_V cal2
 on (cal.Q_WK_ID = cal2.Q_WK_LW or cal.Q_WK_ID = cal2.Q_WK_2WA)
where cal2.Q_DT_ID = current_date
-- Option replace --where cal.Q_WK_ID BETWEEN to_date('02/04/2017', 'mm/dd/yyyy') AND to_date('02/11/2017', 'mm/dd/yyyy')
  and cls.GRP_IDNT between '201' and '270'
  and loc.CHAIN_KEY = 1
/* Test Data
*/
group by cal.Q_WK_ID, rtv.Q_SKU_ID, rtv.Q_STR_ID, sku.Q_SKU_SNUM, loc.Q_STR_DNUM -- ,sku.Q_SKU_DISPLAY
-- END - RTV
UNION
-- Inv Adj
select cal.Q_WK_ID Q_WK_ID, adj.Q_SKU_ID Q_SKU_ID, adj.Q_STR_ID Q_STR_ID,
   sku.Q_SKU_SNUM Sku, loc.Q_STR_DNUM Location, --  sku.Q_SKU_DISPLAY,
cast(NULL as numeric(12,4))  Sales_U_Gross,
cast(NULL as numeric(12,4))  Sales_RDLRS_Gross,
cast(NULL as numeric(12,4))  Sales_U_Net,
cast(NULL as numeric(12,4))  Sales_RDLRS_Net,
cast(NULL as numeric(12,4))  Cogs_CDLRS_x,
cast(NULL as numeric(12,4))  GM_CDLRS,
cast(NULL as numeric(12,4))  Inv_U,
cast(NULL as numeric(12,4))  Inv_CDLRS,
cast(NULL as numeric(12,4))  Inv_RDLRS,
cast(NULL as numeric(12,4))  Cust_Returns_U,
cast(NULL as numeric(12,4))  Curr_OO_U,
cast(NULL as numeric(12,4))  Curr_OO_CDLRS,
cast(NULL as numeric(12,4))  Curr_OO_RDLRS,
cast(NULL as numeric(12,4))  Recvd_U,
cast(NULL as numeric(12,4))  Recvd_CDLRS,
cast(NULL as numeric(12,4))  Recvd_RDLRS,
cast(NULL as numeric(12,4))  Inv_IT_U,
cast(NULL as numeric(12,4))  Inv_IT_CDLRS,
cast(NULL as numeric(12,4))  Inv_IT_RDLRS,
cast(NULL as numeric(12,4))  RTV_U,
   sum(adj.Q_ADJ_QTY) Net_Inv_Adj_U,
cast(NULL as numeric(12,4))  Promo_Mkdn_RDLRS,
cast(NULL as numeric(12,4))  Clrn_Mkdn_RDLRS,
cast(NULL as numeric(12,4))  Reg_Mkdn_RDLRS,
cast(NULL as numeric(12,4))  Total_Mkdn_RDLRS_Str,
cast(NULL as numeric(12,4))  max_Avg_Cost
from Q_PF_INV_ADJ_V adj
join Q_QL_PRD_SKU_V sku
  on (adj.Q_SKU_ID = sku.Q_SKU_ID)
join Q_QL_PRD_CLS_V cls
  on (sku.Q_CLS_ID = cls.Q_CLS_ID)
join Q_QL_LOC_STR_V loc
  on (adj.Q_STR_ID = loc.Q_STR_ID)
join Q_QL_CAL_DT_V cal
  on (adj.Q_DT_ID = cal.Q_DT_ID)
-- Option
join Q_QL_CAL_DT_V cal2
 on (cal.Q_WK_ID = cal2.Q_WK_LW or cal.Q_WK_ID = cal2.Q_WK_2WA)
where cal2.Q_DT_ID = current_date
-- Option replace --where cal.Q_WK_ID BETWEEN to_date('02/04/2017', 'mm/dd/yyyy') AND to_date('02/11/2017', 'mm/dd/yyyy')
  and cls.GRP_IDNT between '201' and '270'
  and loc.CHAIN_KEY = 1
/* Test Data
*/
group by cal.Q_WK_ID, adj.Q_SKU_ID, adj.Q_STR_ID, sku.Q_SKU_SNUM, loc.Q_STR_DNUM -- ,sku.Q_SKU_DISPLAY
-- END - Inv Adj
UNION
-- Ship Receipts
select cal.Q_WK_ID Q_WK_ID, rcpt.Q_SKU_ID Q_SKU_ID, rcpt.Q_STR_ID Q_STR_ID,
   sku.Q_SKU_SNUM Sku, loc.Q_STR_DNUM Location, --  sku.Q_SKU_DISPLAY,
cast(NULL as numeric(12,4))  Sales_U_Gross,
cast(NULL as numeric(12,4))  Sales_RDLRS_Gross,
cast(NULL as numeric(12,4))  Sales_U_Net,
cast(NULL as numeric(12,4))  Sales_RDLRS_Net,
cast(NULL as numeric(12,4))  Cogs_CDLRS_x,
cast(NULL as numeric(12,4))  GM_CDLRS,
cast(NULL as numeric(12,4))  Inv_U,
cast(NULL as numeric(12,4))  Inv_CDLRS,
cast(NULL as numeric(12,4))  Inv_RDLRS,
cast(NULL as numeric(12,4))  Cust_Returns_U,
cast(NULL as numeric(12,4))  Curr_OO_U,
cast(NULL as numeric(12,4))  Curr_OO_CDLRS,
cast(NULL as numeric(12,4))  Curr_OO_RDLRS,
   sum(rcpt.SHP_QTY_RECEIVED_IN) Recvd_U,
   sum(rcpt.SHP_CDLRS_IN) Recvd_CDLRS,
   sum(rcpt.SHP_RDLRS_IN) Recvd_RDLRS,
cast(NULL as numeric(12,4))  Inv_IT_U,
cast(NULL as numeric(12,4))  Inv_IT_CDLRS,
cast(NULL as numeric(12,4))  Inv_IT_RDLRS,
cast(NULL as numeric(12,4))  RTV_U,
cast(NULL as numeric(12,4))  Net_Inv_Adj_U,
cast(NULL as numeric(12,4))  Promo_Mkdn_RDLRS,
cast(NULL as numeric(12,4))  Clrn_Mkdn_RDLRS,
cast(NULL as numeric(12,4))  Reg_Mkdn_RDLRS,
cast(NULL as numeric(12,4))  Total_Mkdn_RDLRS_Str,
cast(NULL as numeric(12,4))  max_Avg_Cost
from Q_QF_SHIP_DTL_IN_V rcpt
join Q_QL_PRD_SKU_V sku
  on (rcpt.Q_SKU_ID = sku.Q_SKU_ID)
join Q_QL_PRD_CLS_V cls
  on (sku.Q_CLS_ID = cls.Q_CLS_ID)
join Q_QL_LOC_STR_V loc
  on (rcpt.Q_STR_ID = loc.Q_STR_ID)
join Q_QL_CAL_DT_V cal
  on (rcpt.SHP_RECEIVE_DATE = cal.Q_DT_ID)
-- Option
join Q_QL_CAL_DT_V cal2
 on (cal.Q_WK_ID = cal2.Q_WK_LW or cal.Q_WK_ID = cal2.Q_WK_2WA)
where cal2.Q_DT_ID = current_date
-- Option replace --where cal.Q_WK_ID BETWEEN to_date('02/04/2017', 'mm/dd/yyyy') AND to_date('02/11/2017', 'mm/dd/yyyy')
  and cls.GRP_IDNT between '201' and '270'
  and loc.CHAIN_KEY = 1
  and rcpt.SHP_TYPE_ID in (1)
/* Test Data
*/
group by cal.Q_WK_ID, rcpt.Q_SKU_ID, rcpt.Q_STR_ID, sku.Q_SKU_SNUM, loc.Q_STR_DNUM -- ,sku.Q_SKU_DISPLAY
-- END - Ship Receipts
UNION
-- On Order
-- Option replace --select  to_date('02/11/2017', 'mm/dd/yyyy')  Q_WK_ID,  -- ** Optional hard coded week
select  cal2.Q_WK_LW  Q_WK_ID,  -- ** Optional hard coded week to last week of date range
   oo.Q_SKU_ID Q_SKU_ID, oo.Q_STR_ID Q_STR_ID,
   sku.Q_SKU_SNUM Sku, loc.Q_STR_DNUM Location, --  sku.Q_SKU_DISPLAY,
cast(NULL as numeric(12,4))  Sales_U_Gross,
cast(NULL as numeric(12,4))  Sales_RDLRS_Gross,
cast(NULL as numeric(12,4))  Sales_U_Net,
cast(NULL as numeric(12,4))  Sales_RDLRS_Net,
cast(NULL as numeric(12,4))  Cogs_CDLRS_x,
cast(NULL as numeric(12,4))  GM_CDLRS,
cast(NULL as numeric(12,4))  Inv_U,
cast(NULL as numeric(12,4))  Inv_CDLRS,
cast(NULL as numeric(12,4))  Inv_RDLRS,
cast(NULL as numeric(12,4))  Cust_Returns_U,
   sum(oo.Q_PO_BOO_UNTS) Curr_OO_U,
   sum(oo.Q_PO_BOO_CDLRS) Curr_OO_CDLRS,
   sum(oo.Q_PO_BOO_RDLRS) Curr_OO_RDLRS,
cast(NULL as numeric(12,4))  Recvd_U,
cast(NULL as numeric(12,4))  Recvd_CDLRS,
cast(NULL as numeric(12,4))  Recvd_RDLRS,
cast(NULL as numeric(12,4))  Inv_IT_U,
cast(NULL as numeric(12,4))  Inv_IT_CDLRS,
cast(NULL as numeric(12,4))  Inv_IT_RDLRS,
cast(NULL as numeric(12,4))  RTV_U,
cast(NULL as numeric(12,4))  Net_Inv_Adj_U,
cast(NULL as numeric(12,4))  Promo_Mkdn_RDLRS,
cast(NULL as numeric(12,4))  Clrn_Mkdn_RDLRS,
cast(NULL as numeric(12,4))  Reg_Mkdn_RDLRS,
cast(NULL as numeric(12,4))  Total_Mkdn_RDLRS_Str,
cast(NULL as numeric(12,4))  max_Avg_Cost
from ADMIN.Q_QF_PO_DTL_V oo
join Q_QL_PRD_SKU_V sku
  on (oo.Q_SKU_ID = sku.Q_SKU_ID)
join Q_QL_PRD_CLS_V cls
  on (sku.Q_CLS_ID = cls.Q_CLS_ID)
join Q_QL_LOC_STR_V loc
  on (oo.Q_STR_ID = loc.Q_STR_ID)
CROSS join Q_QL_CAL_DT_V cal2
-- -- on (cal.Q_WK_ID = cal2.Q_WK_LW or cal.Q_WK_ID = cal2.Q_WK_2WA)
where cal2.Q_DT_ID = current_date
  and cls.GRP_IDNT between '201' and '270'
  and loc.CHAIN_KEY = 1
  and oo.Q_PO_STATUS_ID in (1)
  and oo.Q_PO_DELETE_DT in (To_Date('01/01/1900', 'mm/dd/yyyy'))
/* Test Data
*/
group by cal2.Q_WK_LW, oo.Q_SKU_ID, oo.Q_STR_ID, sku.Q_SKU_SNUM, loc.Q_STR_DNUM -- ,sku.Q_SKU_DISPLAY
-- END - On Order
--
) x -----
LEFT OUTER JOIN Q_QF_ITEM_LOC_V itloc
on (x.Q_SKU_ID = itloc.Q_SKU_ID
        and x.Q_STR_ID = itloc.Q_STR_ID)
group by x.Q_WK_ID, x.Q_SKU_ID, x.Q_STR_ID, x.Sku, x.Location, itloc.Q_INV_SELLING_UNT_RETL --  , sku.Q_SKU_DISPLAY
order by x.Sku, Location, x.Q_WK_ID
;

