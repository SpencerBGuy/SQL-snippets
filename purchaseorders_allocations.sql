WITH 
product AS              --filter by dept
  (SELECT item
  , dept
  FROM item_master
  WHERE dept IN ('353')
),
open_orders AS          --view of orders in Status A with ordered units > received units
  (SELECT ol.order_no 
  , ol.item
  , ol.location
  , oh.po_type
  , oh.order_type
  , oh.not_before_date
  , oh.not_after_date
  , oh.otb_eow_date
  , SUM(ol.qty_ordered) AS qty_ordered
  , SUM(NVL(ol.qty_received,0)) AS qty_received
  FROM ordhead oh
  , ordloc ol
  WHERE oh.order_no = ol.order_no
  AND oh.status = 'A'
  AND ol.qty_ordered  > NVL(ol.qty_received,0)
--  AND ol.order_no in ('18701212')     --optional filter for specific PO's
  GROUP BY ol.order_no
  , ol.item
  , ol.location
  , oh.po_type
  , oh.order_type
  , oh.not_before_date
  , oh.not_after_date
  , oh.otb_eow_date
  ),
allocations AS          --view of all allocations
  (SELECT ah.alloc_no
  , ah.order_no
  , ah.item
  , ad.to_loc
  , NVL(ad.qty_allocated,0) AS qty_allocated
  , NVL(ad.qty_received,0) AS qty_received
  FROM alloc_header ah
  , alloc_detail ad
  WHERE ah.alloc_no = ad.alloc_no
  )
SELECT p.dept       --main query on above views
, oo.order_no
, oo.po_type
, oo.order_type
, oo.not_before_date
, oo.not_after_date
, oo.otb_eow_date
, oo.item
, CASE WHEN oo.po_type = 0 THEN oo.location ELSE aa.to_loc END AS loc
, SUM(oo.qty_ordered) AS order_qty
, CASE WHEN SUM(NVL(aa.qty_allocated,0)) - SUM(NVL(aa.qty_received,0)) = 0 
  THEN SUM(oo.qty_ordered) - SUM(NVL(oo.qty_received,0))
  ELSE SUM(NVL(aa.qty_allocated,0)) - SUM(NVL(aa.qty_received,0))
  END AS open_qty
FROM open_orders oo
, allocations aa
, product p
WHERE oo.order_no = aa.order_no(+)
AND oo.item = aa.item(+)
AND oo.item = p.item
AND (oo.qty_ordered - oo.qty_received) >0
GROUP BY p.dept
, oo.order_no
, oo.po_type
, oo.order_type
, oo.not_before_date
, oo.not_after_date
, oo.otb_eow_date
, oo.item
, CASE WHEN oo.po_type = 0 THEN oo.location ELSE aa.to_loc END
;