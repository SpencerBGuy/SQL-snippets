SELECT oo.Q_DPT_DISPLAY
, oo.Q_PO_HDR_KEY
, oo.Q_PO_TYPE
, oo.Q_PO_DELIVER_DT
, oo.Q_PO_SHIP_DUE_DT
, oo.Q_PO_OTB_DT
, oo.Q_SKU_DISPLAY
, CASE WHEN oo.Q_PO_TYPE = 0 THEN oo.Q_STR_DISPLAY ELSE aa.Q_STR_DISPLAY END AS loc
, SUM(oo.qty_ordered) AS order_qty
, CASE WHEN SUM(NVL(aa.qty_allocated,0)) - SUM(NVL(aa.qty_received,0)) = 0 
  THEN SUM(oo.qty_ordered) - SUM(NVL(oo.qty_received,0))
  ELSE SUM(NVL(aa.qty_allocated,0)) - SUM(NVL(aa.qty_received,0))
  END AS open_qty
FROM(
SELECT	cv.Q_DPT_ID  Q_DPT_ID
,   MAX(dv.Q_DPT_DISPLAY)  Q_DPT_DISPLAY
,   ol.Q_PO_HDR_KEY  Q_PO_HDR_KEY
, 	ohd.Q_PO_DELIVER_DT  Q_PO_DELIVER_DT
, 	ol.Q_PO_SHIP_DUE_DT  Q_PO_SHIP_DUE_DT
, 	ohd.Q_PO_OTB_DT  Q_PO_OTB_DT
, 	ohd.Q_PO_TYPE  Q_PO_TYPE
, 	MAX(ls.Q_STR_DISPLAY)  Q_STR_DISPLAY
, 	ol.Q_SKU_ID  Q_SKU_ID
, 	MAX(sv.Q_SKU_SNUM)  Q_SKU_DISPLAY
, 	SUM(ol.Q_PO_UNTS)  qty_ordered
, 	SUM(NVL(ol.Q_PO_RCVD_UNTS,0))  qty_received
FROM	Q_QF_PO_DTL_V	ol
	JOIN	Q_QF_PO_HDR_V ohd
	  ON 	(ol.Q_PO_CREATE_DT = ohd.Q_PO_CREATE_DT AND
	ol.Q_PO_HDR_KEY = ohd.Q_PO_HDR_KEY)
	JOIN	Q_QL_PRD_SKU_V	sv
	  ON 	(ol.Q_SKU_ID = sv.Q_SKU_ID)
	JOIN	Q_QL_PRD_CLS_V	cv
	  ON 	(sv.Q_CLS_ID = cv.Q_CLS_ID)
	JOIN	Q_QL_LOC_STR_V	ls
	  ON 	(ol.Q_STR_ID = ls.Q_STR_ID)
	JOIN	Q_QL_PRD_DPT_V	dv
	  ON 	(cv.Q_DPT_ID = dv.Q_DPT_ID)
WHERE	(ol.Q_PO_STATUS_ID IN (1)
 AND ol.Q_PO_DELETE_DT IN (To_Date('01/01/1900', 'mm/dd/yyyy'))
 AND cv.Q_DPT_ID IN ([?PA758934ED42BF0AF5DF221E8CDA5FDD24##[?))
GROUP BY	cv.Q_DPT_ID
,   dv.Q_DPT_DISPLAY
,   ol.Q_PO_HDR_KEY
, 	ohd.Q_PO_DELIVER_DT
, 	ol.Q_PO_SHIP_DUE_DT
, 	ohd.Q_PO_OTB_DT
, 	ohd.Q_PO_TYPE
, 	ls.Q_STR_DISPLAY
, 	ol.Q_SKU_ID
, 	sv.Q_SKU_SNUM
) OO LEFT OUTER JOIN
(
SELECT	cv.Q_DPT_ID  Q_DPT_ID
,	  MAX(dv.Q_DPT_DISPLAY)  Q_DPT_DISPLAY
,	  ad.Q_SKU_ID  Q_SKU_ID
,   ah.Q_PO_HDR_KEY  Q_PO_HDR_KEY
,	  MAX(sv.Q_SKU_SNUM)  Q_SKU_DISPLAY
,	  ad.Q_STR_ID  Q_STR_ID
,	  MAX(ls.Q_STR_DISPLAY)  Q_STR_DISPLAY
,	  SUM(ad.Q_ALLOC_UNTS)  qty_allocated
, 	SUM(ad.Q_ALLOC_RCVD_UNTS)  qty_received
FROM	Q_QF_ALLOC_DTL_V	ad
	JOIN	Q_QF_ALLOC_HDR_V	ah
	  ON 	(ad.Q_ALLOC_HDR_ID = ah.Q_ALLOC_HDR_ID AND 
	ad.Q_DT_ID = ah.Q_DT_ID AND
	ad.Q_SKU_ID = ah.Q_SKU_ID)
	JOIN	Q_QL_PRD_SKU_V	sv
	  ON 	(ad.Q_SKU_ID = sv.Q_SKU_ID)
	JOIN	Q_QL_PRD_CLS_V	cv
	  ON 	(sv.Q_CLS_ID = cv.Q_CLS_ID)
	JOIN	Q_QL_LOC_STR_V	ls
	  ON 	(ad.Q_STR_ID = ls.Q_STR_ID)
	JOIN	Q_QL_PRD_DPT_V	dv
	  ON 	(cv.Q_DPT_ID = dv.Q_DPT_ID)
WHERE	(ah.Q_ALLOC_STATUS IN ('A')
 AND ad.Q_ALLOC_DEL_DT IN (To_Date('01/01/1900', 'mm/dd/yyyy'))
 AND cv.Q_DPT_ID IN ([?PA758934ED42BF0AF5DF221E8CDA5FDD24##[?))
GROUP BY	cv.Q_DPT_ID
,	  dv.Q_DPT_DISPLAY
,	  ad.Q_SKU_ID
,   ah.Q_PO_HDR_KEY
,	  sv.Q_SKU_SNUM
,	  ad.Q_STR_ID
,	  ls.Q_STR_DISPLAY
  )aa ON (oo.Q_PO_HDR_KEY = aa.Q_PO_HDR_KEY AND oo.Q_SKU_ID = aa.Q_SKU_ID)
WHERE oo.qty_ordered - oo.qty_received > 0
GROUP BY	oo.Q_DPT_DISPLAY
, oo.Q_PO_HDR_KEY
, oo.Q_PO_TYPE
, oo.Q_PO_DELIVER_DT
, oo.Q_PO_SHIP_DUE_DT
, oo.Q_PO_OTB_DT
, oo.Q_SKU_DISPLAY
, CASE WHEN oo.Q_PO_TYPE = 0 THEN oo.Q_STR_DISPLAY ELSE aa.Q_STR_DISPLAY END
;