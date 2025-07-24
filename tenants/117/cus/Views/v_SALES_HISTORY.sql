



-- ===============================================================================
-- Author:      Paulo Marques
-- Description: Sales history mapping from raw to adi
--
--  24.09.2024.TO   Altered
-- ===============================================================================


CREATE VIEW [cus].[v_SALES_HISTORY] AS


-- sale history from ERP
	SELECT
        CAST(NULL AS BIGINT)															AS [TRANSACTION_ID],
		CAST(ptt.[PartNum] AS NVARCHAR(255))											AS [ITEM_NO],

		CAST(COALESCE(IIF(pt.[Part_FFS_Overide_c]='',NULL,IIF(pt.[Part_FFS_Overide_c]='UK','MfgSys',pt.Part_FFS_Overide_c)),
			 					 IIF(ct.[Customer_fulfilsite_c]='UK','MfgSys',ct.Customer_fulfilsite_c),
			 					 ptt.[Plant]) AS NVARCHAR(255))							AS [LOCATION_NO],
		CAST(ptt.[TranDate]  AS DATE)													AS [DATE],
		CAST(SUM(ptt.[ActTranQty]) AS DECIMAL(18,4))									AS [SALE],
		CAST(ct.CustID AS NVARCHAR(255))												AS [CUSTOMER_NO],
		CAST(ptt.LegalNumber AS NVARCHAR(255))											AS [REFERENCE_NO],
		CAST(0 AS BIT)																	AS [IS_EXCLUDED]
	FROM cus.PartTran ptt
		LEFT JOIN cus.Part pt		ON ptt.[PartNum] = pt.[PartNum]
		LEFT JOIN cus.Customer ct	ON ptt.[CustNum] = ct.CustNum
	WHERE ptt.TranType IN ('MFG-CUS', 'STK-CUS')
		AND ptt.WareHouseCode NOT IN ('QA','QAP')
	GROUP BY 
		CAST(ptt.[PartNum] AS NVARCHAR(255)),
		CAST(COALESCE(IIF(pt.[Part_FFS_Overide_c]='',NULL,IIF(pt.[Part_FFS_Overide_c]='UK','MfgSys',pt.Part_FFS_Overide_c)),
					 					 IIF(ct.[Customer_fulfilsite_c]='UK','MfgSys',ct.Customer_fulfilsite_c),
					 					 ptt.[Plant]) AS NVARCHAR(255)),
		ptt.TranDate,
		ct.CustID,
		ptt.LegalNumber

--legacy sale history
UNION ALL

	SELECT
        CAST(NULL AS BIGINT)															AS [TRANSACTION_ID],
		CAST(shl22.ITEM_NO AS NVARCHAR(255))											AS [ITEM_NO],
		CAST(COALESCE(IIF(pt.[Part_FFS_Overide_c]='',NULL,IIF(pt.[Part_FFS_Overide_c]='UK','MfgSys',pt.[Part_FFS_Overide_c])),
			 					 IIF(shl22.LOCATION_NO='UK','MfgSys',shl22.LOCATION_NO)) AS NVARCHAR(255))					AS [LOCATION_NO],
		CAST(CONVERT(DATE, shl22.DATE, 103) AS DATE)										AS [DATE],
		CAST(SUM(shl22.SALE) AS DECIMAL(18,4))											AS [SALE],
		CAST(shl22.CustID AS NVARCHAR(255))												AS [CUSTOMER_NO],
		CAST('' AS NVARCHAR(255))														AS [REFERENCE_NO],
		CAST(0 AS BIT)																	AS [IS_EXCLUDED]
	FROM cus.SALE_HISTORY_LEGACY_2022 shl22
		LEFT JOIN cus.Part pt		ON shl22.ITEM_NO = pt.[PartNum]
	WHERE shl22.LOCATION_NO IS NOT NULL
	GROUP BY 
		shl22.ITEM_NO,
		CAST(COALESCE(IIF(pt.[Part_FFS_Overide_c]='',NULL,IIF(pt.[Part_FFS_Overide_c]='UK','MfgSys',pt.[Part_FFS_Overide_c])),
					 					 IIF(shl22.LOCATION_NO='UK','MfgSys',shl22.LOCATION_NO)) AS NVARCHAR(255)),
		CAST(CONVERT(DATE, shl22.DATE, 103) AS DATE), shl22.CustID

UNION ALL

	SELECT
        CAST(NULL AS BIGINT)															AS [TRANSACTION_ID],
		CAST(shl23.ITEM_NO AS NVARCHAR(255))											AS [ITEM_NO],
		CAST(COALESCE(IIF(pt.[Part_FFS_Overide_c]='',NULL,IIF(pt.[Part_FFS_Overide_c]='UK','MfgSys',pt.[Part_FFS_Overide_c])),
			 					 IIF(shl23.LOCATION_NO='UK','MfgSys',shl23.LOCATION_NO)) AS NVARCHAR(255))					AS [LOCATION_NO],
		CAST(CONVERT(DATE, shl23.DATE, 103) AS DATE)									AS [DATE],
		CAST(SUM(shl23.SALE) AS DECIMAL(18,4))											AS [SALE],
		CAST(shl23.CustID AS NVARCHAR(255))												AS [CUSTOMER_NO],
		CAST('' AS NVARCHAR(255))														AS [REFERENCE_NO],
		CAST(0 AS BIT)																	AS [IS_EXCLUDED]
	FROM cus.SALE_HISTORY_LEGACY_2023 shl23
		LEFT JOIN cus.Part pt		ON shl23.ITEM_NO = pt.[PartNum]
	WHERE shl23.LOCATION_NO IS NOT NULL
	GROUP BY 
		shl23.ITEM_NO,
		CAST(COALESCE(IIF(pt.[Part_FFS_Overide_c]='',NULL,IIF(pt.[Part_FFS_Overide_c]='UK','MfgSys',pt.[Part_FFS_Overide_c])),
					 					 IIF(shl23.LOCATION_NO='UK','MfgSys',shl23.LOCATION_NO)) AS NVARCHAR(255)),
		shl23.DATE, shl23.CustID

UNION ALL

	SELECT
        CAST(NULL AS BIGINT)															AS [TRANSACTION_ID],
		CAST(shl24.ITEM_NO AS NVARCHAR(255))											AS [ITEM_NO],
		CAST(COALESCE(IIF(pt.[Part_FFS_Overide_c]='',NULL,IIF(pt.[Part_FFS_Overide_c]='UK','MfgSys',pt.[Part_FFS_Overide_c])),
			 					 IIF(shl24.LOCATION_NO='UK','MfgSys',shl24.LOCATION_NO)) AS NVARCHAR(255))					AS [LOCATION_NO],
		CAST(CONVERT(DATE, shl24.DATE, 103) AS DATE)										AS [DATE],
		CAST(SUM(shl24.SALE) AS DECIMAL(18,4))											AS [SALE],
		CAST(shl24.CustID AS NVARCHAR(255))												AS [CUSTOMER_NO],
		CAST('' AS NVARCHAR(255))														AS [REFERENCE_NO],
		CAST(0 AS BIT)																	AS [IS_EXCLUDED]
	FROM cus.SALE_HISTORY_LEGACY_2024_2025 shl24
		LEFT JOIN cus.Part pt		ON shl24.ITEM_NO = pt.[PartNum]
	WHERE shl24.LOCATION_NO IS NOT NULL
	GROUP BY 
		shl24.ITEM_NO,
		CAST(COALESCE(IIF(pt.[Part_FFS_Overide_c]='',NULL,IIF(pt.[Part_FFS_Overide_c]='UK','MfgSys',pt.[Part_FFS_Overide_c])),
					 					 IIF(shl24.LOCATION_NO='UK','MfgSys',shl24.LOCATION_NO)) AS NVARCHAR(255)),
		CAST(CONVERT(DATE, shl24.DATE, 103) AS DATE),
		shl24.CustID

	

