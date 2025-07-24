
-- ===============================================================================
-- Author:      JOSÉ SUCENA
-- Description: DK UNDELIVERED_PURCHASE_ORDER mapping to ADI
--
-- 24.10.2024.TO    Created
-- ===============================================================================

  CREATE VIEW [dk_cus].[v_UNDELIVERED_PURCHASE_ORDER] AS

       SELECT
        CAST(pl.[Number] AS NVARCHAR(128))                                      AS [PURCHASE_ORDER_NO],
        CAST(pl.[Lines.ItemCode] AS NVARCHAR(255))                              AS [ITEM_NO],
        CAST(pl.[Lines.Warehouse] AS NVARCHAR(255))                             AS [LOCATION_NO],
        CAST(COALESCE(p.[Arrival.ConfirmedDate], p.[Arrival.FinalDate], 
                           p.[Arrival.RequestedDate], GETDATE()) AS DATE)       AS [DELIVERY_DATE],
        SUM(CAST(pl.[Lines.Quantity] AS DECIMAL(18,4)))                         AS [QUANTITY]
        

    FROM
        [dk].[import_purchase_lines_refresh] pl
    INNER JOIN
        [dk].[import_purchase_refresh] p ON p.[Number] = pl.[Number]
    --where
        --warehouse = 'bg1' and -- only for aðallager íshella
        --p.[Status] = 0
        --[documenttype] = 'order' and  [expectedreceiptdate] <> '1753-01-01 00:00:00.000'
    GROUP BY pl.[Number], 
                pl.[Lines.ItemCode], 
                pl.[Lines.Warehouse], 
                p.[Arrival.ConfirmedDate], 
                p.[Arrival.FinalDate], 
                p.[Arrival.RequestedDate], 
                p.[Status]
        -- ef pöntunin er ekki lengur í json-inum sem kemur inn í dag þá fær hún status = 1, annars 0
        -- status =1 means delivered
        -- status =0 means not delivered

     UNION ALL

	 SELECT 
		'vörumóttaka' AS [PURCHASE_ORDER_NO],
		CAST([ITEMCODE] AS NVARCHAR(255)) AS [ITEM_NO],
		CAST([WAREHOUSE] AS NVARCHAR(255)) AS [LOCATION_NO],
		CONVERT(DATE, DATEADD(DAY, 1, GETDATE())) AS [DELIVERY_DATE],
		SUM(ISNULL(TRY_CAST([QUANTITYINPOJOURNALS] AS DECIMAL(18,4)),0)) AS [QUANTITY]
	FROM [dk].[import_undelivered]
	WHERE ISNULL(TRY_CAST([QUANTITYINPOJOURNALS] AS DECIMAL(18,4)),0) > 0
	GROUP BY [ITEMCODE], [WAREHOUSE];


     --SELECT 
     --     'vörumóttaka'                                                           AS [PURCHASE_ORDER_NO]
     --     ,CAST([ITEMCODE] AS NVARCHAR(255))                                      AS [ITEM_NO]
     --     ,CAST([WAREHOUSE] AS NVARCHAR(255))                                     AS [LOCATION_NO]
     --     ,CONVERT(DATE, DATEADD(DAY, 1, GETDATE()))                              AS [DELIVERY_DATE]
     --     ,SUM(CAST([QUANTITYINPOJOURNALS] AS DECIMAL(18,4)))                     AS [QUANTITY]

     --FROM [dk].[import_undelivered]
     --WHERE --warehouse = 'bg1' and -- only for aðallager íshella
     --CAST([QUANTITYINPOJOURNALS] AS DECIMAL(18,4)) > 0
     --GROUP BY [ITEMCODE], [WAREHOUSE]

