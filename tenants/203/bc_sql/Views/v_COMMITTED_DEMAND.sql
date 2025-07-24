CREATE VIEW [bc_sql_cus].[v_COMMITTED_DEMAND] AS

-- wepet open sales orders

SELECT 
       CAST(sl.[No_] + CASE WHEN ISNULL(sl.[Variant Code], '') = '' THEN '' ELSE '-' + sl.[Variant Code] END AS NVARCHAR(255)) AS [ITEM_NO],
	   CAST('HANDCROSS' AS NVARCHAR(255))									AS [LOCATION_NO],
       SUM(CAST(sl.[Outstanding Qty_ (Base)] AS DECIMAL(18, 4)))             AS [QUANTITY],
       --CAST(sl.[Shipment Date] AS DATE)                                      AS DEMAND_DATE,
	   CAST(
			CASE 
				WHEN sl.[Shipment Date] < CAST(GETDATE() AS DATE) THEN CAST(GETDATE() AS DATE)
				ELSE sl.[Shipment Date]
			END 
		AS DATE)																AS DEMAND_DATE,
       sl.[company]                                                          AS [Company]
FROM bc_sql_cus.SalesLine_WePet sl
         INNER JOIN bc_sql_cus.SalesHeader_WePet sh
                    ON sl.[Document No_] = sh.[No_] AND sl.[Document Type] = sh.[Document Type] and
                       sl.[company] = sh.[company]
WHERE sh.[Document Type] = 1
  AND sl.[Drop Shipment] = 0
GROUP BY sl.[No_], 
	sl.[Variant Code],
    sl.[company], 
	CAST(
          	CASE 
          		WHEN sl.[Shipment Date] < CAST(GETDATE() AS DATE) THEN CAST(GETDATE() AS DATE)
          		ELSE sl.[Shipment Date]
          	END 
        AS DATE)
having SUM(CAST(sl.[Outstanding Qty_ (Base)] AS DECIMAL(18, 4))) <> 0


