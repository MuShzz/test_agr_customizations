



-- ===============================================================================
-- Author:      Paulo Marques
-- Description: Purchase order route mapping from raw to adi
--
--  24.09.2024.TO   Altered
-- ===============================================================================


CREATE VIEW [cus].[v_PURCHASE_ORDER_ROUTE] AS

	WITH RankedVendParts AS 
			   (SELECT *, ROW_NUMBER() OVER (PARTITION BY PartNum ORDER BY EffectiveDate DESC) AS RowNum FROM cus.VendPart)
       SELECT
            CAST(cpp.[PartNum] AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(cpp.[Plant] AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(vd.[VendorID] AS NVARCHAR(255)) AS [VENDOR_NO],
            CAST(1 AS BIT) AS [PRIMARY],
            CAST(IIF(cvp.[LeadTime]=0,NULL,cvp.[LeadTime]) AS SMALLINT) AS [LEAD_TIME_DAYS],
            CAST(NULL AS SMALLINT) AS [ORDER_FREQUENCY_DAYS],
            CAST(cpp.[MinOrderQty] AS DECIMAL(18, 4)) AS [MIN_ORDER_QTY],
            CAST(NULL AS DECIMAL(18, 4)) AS [COST_PRICE],
            CAST(cvp.[BaseUnitPrice] AS DECIMAL(18, 4)) AS [PURCHASE_PRICE],
            CAST(NULL AS DECIMAL(18, 4)) AS [ORDER_MULTIPLE],
            CAST(NULL AS DECIMAL(18, 4)) AS [QTY_PALLET]
       FROM cus.PartPlant cpp
	 INNER JOIN (SELECT * FROM RankedVendParts WHERE RowNum = 1) AS cvp ON cpp.[PartNum] = cvp.[PartNum] AND cpp.[VendorNum] = cvp.[VendorNum]
	 LEFT JOIN cus.Vendor vd ON vd.VendorNum = cpp.VendorNum


