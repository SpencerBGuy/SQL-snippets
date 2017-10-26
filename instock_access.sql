SELECT x.week, x.version, FORMAT(Sum(x.itemloc_count), "#,##0") AS itemloc_count, FORMAT(Sum(y.NIS), "#,##0") AS NIS, FORMAT(1-(Sum(y.NIS)/Sum(x.itemloc_count)), "Percent") AS Instock
FROM (SELECT week, version, loc, item, item_desc, COUNT(*) AS itemloc_count 
FROM (SELECT DISTINCT week, version, item, item_desc, loc, date 
FROM performance_history 
WHERE week >"1"
AND version >= "A")  AS [%$##@_Alias] 
GROUP BY week, version, loc, item, item_desc)  AS x LEFT JOIN (SELECT week, version, loc, item, item_desc, COUNT(*) AS NIS 
FROM (SELECT week, version, loc, item, item_desc, date, IIF(ISNULL(oh_u), 0, oh_u) AS Inv, IIF(ISNULL(sls_u), 0, sls_u) AS Sales 
FROM Performance_History 
WHERE week > "1"
AND version >="A"
AND IIF(ISNULL(oh_u), 0, oh_u) <=0 
AND IIF(ISNULL(sls_u), 0, sls_u) <=0)  AS [%$##@_Alias] 
GROUP BY week, version, loc, item, item_desc)  AS y ON (x.version = y.version) AND (x.week = y.week) AND (x.item = y.item) AND (x.loc = y.loc) AND (x.item_desc = y.item_desc)
GROUP BY x.week, x.version
;
