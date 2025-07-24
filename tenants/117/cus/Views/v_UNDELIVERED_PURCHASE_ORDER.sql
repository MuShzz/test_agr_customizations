



-- ===============================================================================
-- Author:      Paulo Marques
-- Description: Undelivered purchase order mapping from raw to adi
--
-- 24.09.2024.TO    Altered
-- ===============================================================================

CREATE VIEW [cus].[v_UNDELIVERED_PURCHASE_ORDER] AS
	SELECT
		CAST(CONCAT(CAST(cp.[PONum] AS NVARCHAR(128)), CAST(100000+cpd.[POLine] AS NVARCHAR(128))) AS VARCHAR(128)) AS [PURCHASE_ORDER_NO],
		CAST(cpd.[PartNum] AS NVARCHAR(255)) AS [ITEM_NO],
		CAST(ISNULL(cpl.[Plant],cpl.[Plant1]) AS NVARCHAR(255)) AS [LOCATION_NO],
		CAST(cpd.[DueDate] AS DATE) AS [DELIVERY_DATE],
		SUM(CAST((cpd.[OrderQty]-pr.ReceivedQty) AS DECIMAL(18, 4))) AS [QUANTITY]
	FROM cus.[POHeader] cp
		INNER JOIN cus.[PODetail] cpd ON cp.[PONum] = cpd.[PONUM]
		INNER JOIN cus.Plant cpl ON cp.[ShipName] = cpl.[Name]
		LEFT JOIN cus.PORels pr ON pr.PONum = cp.PONum AND pr.Plant = cpl.Plant AND pr.POLine = cpd.POLine
	WHERE cpd.[DueDate] IS NOT NULL
	GROUP BY
		CAST(CONCAT(CAST(cp.[PONum] AS NVARCHAR(128)), CAST(100000+cpd.[POLine] AS NVARCHAR(128))) AS VARCHAR(128)),
		cpd.PartNum,
		CAST(ISNULL(cpl.[Plant],cpl.[Plant1]) AS NVARCHAR(255)),
		cpd.DueDate
	HAVING SUM(CAST((cpd.[OrderQty]-pr.ReceivedQty) AS DECIMAL(18, 4)))>0


