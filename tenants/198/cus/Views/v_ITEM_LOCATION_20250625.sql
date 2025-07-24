
CREATE VIEW [cus].[v_ITEM_LOCATION_20250625]
             AS
            SELECT
               CAST([product] AS NVARCHAR(255)) AS [ITEM_NO],
               CAST([plant] AS NVARCHAR(255)) AS [LOCATION_NO],
               CAST(NULL AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS],
               CAST(0 AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK],
               CAST(NULL AS DECIMAL(18,4)) AS [MAX_STOCK],
               CASE WHEN MRPType='PD' OR MRPType=''
				OR ipl.MRPType='ND'
				THEN CAST(1 AS BIT)
				ELSE
			   CAST(0 AS BIT) END AS [CLOSED],
               CAST(NULL AS BIT) AS [CLOSED_FOR_ORDERING],
               CASE WHEN re.name IS NULL THEN ipl.PurchasingGroup
				ELSE 
				ipl.PurchasingGroup+'-'+ISNULL(re.name,'') END AS [RESPONSIBLE],
               CAST(NULL AS NVARCHAR(255)) AS [NAME],
               CAST(NULL AS NVARCHAR(1000)) AS [DESCRIPTION],
               CAST(NULL AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO],
               CAST(NULL AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS],
               CAST(NULL AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS],
               CAST(NULL AS SMALLINT) AS [ORDER_FREQUENCY_DAYS],
               CAST(NULL AS SMALLINT) AS [ORDER_COVERAGE_DAYS],
               CAST(NULL AS DECIMAL(18,4)) AS [MIN_ORDER_QTY],
               CAST(NULL AS NVARCHAR(50)) AS [ORIGINAL_NO],
               CAST(NULL AS DECIMAL(18,4)) AS [SALE_PRICE],
               CAST(NULL AS DECIMAL(18,4)) AS [COST_PRICE],
               CAST(NULL AS DECIMAL(18,4)) AS [PURCHASE_PRICE],
               CAST(NULL AS DECIMAL(18,4)) AS [ORDER_MULTIPLE],
               CAST(NULL AS DECIMAL(18,4)) AS [QTY_PALLET],
               CAST(NULL AS DECIMAL(18,4)) AS [VOLUME],
               CAST(NULL AS DECIMAL(18,4)) AS [WEIGHT],
               CAST(0 AS DECIMAL(18,4)) AS [REORDER_POINT],
               CAST(1 AS BIT) AS [INCLUDE_IN_AGR],
               CAST(NULL AS BIT) AS [SPECIAL_ORDER]
                FROM cus.ItemPlant ipl
		  INNER JOIN cus.v_LOCATION loc ON loc.NO=ipl.Plant
		  LEFT JOIN cus.responsible re ON ipl.PurchasingGroup=re.no
		  WHERE ipl.plant NOT IN ('7029','7021','7001'
		   ,'7007'
		   ,'7010'
		   ,'7011'
		   ,'7012'
		   ,'7016'
		   ,'7018'
		   ,'7026'
		   ,'7028'
		   ,'7031'
		   ,'7002' 
		   ,'7003'
		   ,'7004'
		   ,'7005'
		   ,'7006'
		   ,'7008'
		   ,'7009'
		   ,'7013'
		   ,'7014'
		   ,'7015'
		   ,'7017'
		   ,'7019'
		   ,'7020'
		   ,'7022'
		   ,'7023'
		   ,'7024'
		   ,'7025'
		   ,'7027'
		   ,'7032'
		   ,'7033'
		   ,'7034'
		   ,'7035'
		   ,'7030'
		   )

		   UNION ALL


		   SELECT
               CAST([product] AS NVARCHAR(255)) AS [ITEM_NO],
               CAST([plant] AS NVARCHAR(255)) AS [LOCATION_NO],
               CAST(NULL AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS],
               CAST(0 AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK],
               CAST(NULL AS DECIMAL(18,4)) AS [MAX_STOCK],
               CASE WHEN ipl.MRPType='YD' 
				THEN CAST(0 AS BIT)
				ELSE
              CAST(1 AS BIT) END AS [CLOSED],
               CAST(NULL AS BIT) AS [CLOSED_FOR_ORDERING],
               CASE WHEN re.name IS NULL THEN ipl.PurchasingGroup
			  ELSE 
              ipl.PurchasingGroup+'-'+ISNULL(re.name,'') END AS [RESPONSIBLE],
               CAST(NULL AS NVARCHAR(255)) AS [NAME],
               CAST(NULL AS NVARCHAR(1000)) AS [DESCRIPTION],
               CAST(NULL AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO],
               CAST(NULL AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS],
               CAST(NULL AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS],
               CAST(NULL AS SMALLINT) AS [ORDER_FREQUENCY_DAYS],
               CAST(NULL AS SMALLINT) AS [ORDER_COVERAGE_DAYS],
               CAST(NULL AS DECIMAL(18,4)) AS [MIN_ORDER_QTY],
               CAST(NULL AS NVARCHAR(50)) AS [ORIGINAL_NO],
               CAST(NULL AS DECIMAL(18,4)) AS [SALE_PRICE],
               CAST(NULL AS DECIMAL(18,4)) AS [COST_PRICE],
               CAST(NULL AS DECIMAL(18,4)) AS [PURCHASE_PRICE],
               CAST(NULL AS DECIMAL(18,4)) AS [ORDER_MULTIPLE],
               CAST(NULL AS DECIMAL(18,4)) AS [QTY_PALLET],
               CAST(NULL AS DECIMAL(18,4)) AS [VOLUME],
               CAST(NULL AS DECIMAL(18,4)) AS [WEIGHT],
               CAST(NULL AS DECIMAL(18,4)) AS [REORDER_POINT],
               CAST(1 AS BIT) AS [INCLUDE_IN_AGR],
               CAST(NULL AS BIT) AS [SPECIAL_ORDER]
			   FROM cus.ItemPlant ipl
		  LEFT JOIN cus.responsible re ON ipl.PurchasingGroup=re.no
		   INNER JOIN cus.v_LOCATION loc ON loc.NO=ipl.Plant
		   WHERE ipl.plant IN ('7029','7021'

		    ,'7001'
		   ,'7007'
		   ,'7010'
		   ,'7011'
		   ,'7012'
		   ,'7016'
		   ,'7018'
		   ,'7026'
		   ,'7028'
		   ,'7031'

		   ,'7002' 
		   ,'7003'
		   ,'7004'
		   ,'7005'
		   ,'7006'
		   ,'7008'
		   ,'7009'
		   ,'7013'
		   ,'7014'
		   ,'7015'
		   ,'7017'
		   ,'7019'

		   ,'7020'
		   ,'7022'
		   ,'7023'
		   ,'7024'
		   ,'7025'
		   ,'7027'
		   ,'7032'
		   ,'7033'
		   ,'7034'
		   ,'7035'

		   ,'7030'

		   )


