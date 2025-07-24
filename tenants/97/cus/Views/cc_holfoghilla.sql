

CREATE VIEW [cus].[cc_holfoghilla] AS

SELECT DISTINCT 
    aei.[itemNo],
	aei.locationNo,
	cust.[Shelf No_] AS columnValue,
    7 AS customColumnId
FROM [dbo].[AGREssentials_items] aei
INNER JOIN [cus].Item cust ON aei.itemNo = cust.[No_]
      AND cust.Company = RIGHT(aei.[locationNo], 3)


