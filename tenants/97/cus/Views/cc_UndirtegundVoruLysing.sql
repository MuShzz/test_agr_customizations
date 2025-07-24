


CREATE VIEW [cus].[cc_UndirtegundVoruLysing] AS

	SELECT DISTINCT 
	aei.[itemNo]
	,aei.[locationNo]
	,2 AS customColumnId
	,cust.[Description] AS columnValue
FROM [dbo].[AGREssentials_items] aei
INNER JOIN cus.Item i ON aei.[itemNo] = i.[No_] AND i.Company = RIGHT(aei.[locationNo], 3)
INNER JOIN cus.ProductSubgroup cust ON i.[Product Subgroup Code] = cust.Code AND i.[Product Group Code] = cust.[Product Group Code] AND i.Company = cust.Company
WHERE cust.[Description] IS NOT NULL AND cust.[Description] <> ''


