


CREATE VIEW [cus].[cc_UndirtegundVoruKoti] AS

SELECT DISTINCT 
	aei.[itemNo]
	,aei.[locationNo]
	,1 AS customColumnId
	,cust.[Product Subgroup Code] AS columnValue
FROM [dbo].[AGREssentials_items] aei
INNER JOIN [cus].[Item] cust 
	ON aei.[itemNo] = cust.[No_]
   AND cust.Company = RIGHT(aei.[locationNo], 3)
WHERE cust.[Product Subgroup Code] IS NOT NULL AND cust.[Product Subgroup Code] <> ''
  


