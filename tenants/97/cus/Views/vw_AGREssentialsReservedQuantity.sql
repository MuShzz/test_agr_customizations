




CREATE VIEW [cus].[vw_AGREssentialsReservedQuantity] AS


WITH CTE AS(
SELECT DISTINCT 
    aei.[itemNo],
    CASE
		WHEN cust.[Location Code] IN ('01','02','22') AND cust.Company = 'BLI' THEN '01-BLI'
		WHEN cust.[Location Code] IN ('01','07','19') AND cust.Company = 'JLR' THEN '01-JLR'
		WHEN cust.[Location Code] IN ('09','18') THEN '08-HYU'
		WHEN cust.[Location Code] IN ('12','13') THEN '12-HYU'
	END AS locationNo,
    6 AS customColumnId,
    CAST(SUM(cust.Quantity) AS INT) AS columnValue
FROM [dbo].[AGREssentials_items] aei
INNER JOIN [cus].ServiceLineEDMS cust ON aei.itemNo = cust.[No_] 
WHERE [Document No_] LIKE 'VB%' AND cust.[Location Code] IN ('01','02','22','01','07','19','09','18','12','13') --AND aei.itemNo = 'RE135977'
GROUP BY aei.itemNo, aei.locationNo,aei.locationNo,cust.[Location Code],cust.Company

)

SELECT 
	aei.itemNo,
	aei.locationNo,
	6 AS customColumnId,
	ISNULL(SUM(cte.columnValue),0) AS columnValue
FROM dbo.AGREssentials_items aei
LEFT JOIN CTE ON aei.[itemNo] = CTE.itemNo
GROUP BY aei.itemNo,aei.locationNo,CTE.customColumnId

