




CREATE VIEW [cus].[cc_saleqtylast24months] AS


SELECT DISTINCT 
    aei.[itemNo],
	aei.locationNo,
	CAST(SUM(CASE WHEN cust.date BETWEEN DATEADD(MONTH, -24, GETDATE()) AND DATEADD(DAY, -1, GETDATE()) THEN cust.sale ELSE 0 END) AS INT) AS columnValue,
    9 AS customColumnId
FROM [dbo].[AGREssentials_items] aei
INNER JOIN erp_raw.sale_history cust ON aei.itemNo = cust.product_item_no AND aei.locationNo = cust.location_no
GROUP BY aei.itemNo,
         aei.locationNo


