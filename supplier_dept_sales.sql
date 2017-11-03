--Sales by Supplier, Dept, Item
SELECT  im.dept, sups.supplier, im.item, im.item_desc, TO_CHAR(SUM(sales_issues),'9,999,999,999') AS units, TO_CHAR(SUM(value),'9,999,999,999') AS retail
  FROM item_loc_hist ilh

  --Add Supplier to output
  --Subquery to sort Suppliers on primary_supp_ind to grab primary first, if no primary select first record
  JOIN (SELECT *
        FROM (SELECT DISTINCT primary_supp_ind, supplier, item, (ROW_NUMBER() OVER(PARTITION BY item ORDER BY primary_supp_ind DESC)) AS Rank
              FROM item_supp_country) tmp
        WHERE tmp.Rank=1) sups
  ON ilh.item = sups.item 
  
  --Add item_master to select by Dept
  JOIN item_master im
  ON ilh.item = im.item

  WHERE im.dept IN ('597','604','836') -- ENTER DEPT HERE
  AND ilh.month_454 = 10 -- ENTER MONTH HERE (October=10)
  --AND eow_date in ('07-OCT-2017', '14-OCT-2017', '21-OCT-2017', '28-OCT-2017') -- ENTER WEEKS BY EOW DATE HERE
  AND ilh.year_454 = 2017
  AND ilh.loc_type = 'S'
  AND ilh.loc IN ('109') -- ENTER LOCATIONS HERE
  
GROUP BY im.dept, sups.supplier, im.item, im.item_desc
ORDER BY im.dept, sups.supplier
;