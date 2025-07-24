





-- ===============================================================================
-- Author:      Paulo Marques
-- Description: bom consumption from raw to adi
--
--  24.09.2024.TO   Altered
-- ===============================================================================

CREATE VIEW [cus].[v_BOM_CONSUMPTION_HISTORY] AS
    SELECT
        CAST(NULL AS BIGINT) AS TRANSACTION_ID,
        CAST(ptt.[PartNum] AS NVARCHAR(255)) AS ITEM_NO,
        CAST(COALESCE(IIF(pt.[Part_FFS_Overide_c]='',NULL,IIF(pt.[Part_FFS_Overide_c]='UK','MfgSys',pt.Part_FFS_Overide_c)),
			 					 IIF(ct.[Customer_fulfilsite_c]='UK','MfgSys',ct.Customer_fulfilsite_c),
							 ptt.[Plant]) AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(ptt.[TranDate] AS DATE)          AS [DATE],
        CAST(SUM(ptt.[ActTranQty]) AS DECIMAL(18,4)) AS [UNIT_QTY]
    FROM cus.PartTran ptt
		LEFT JOIN cus.Part pt ON ptt.[PartNum] = pt.[PartNum]
		LEFT JOIN cus.Customer ct ON ptt.[CustNum] = ct.CustNum
	WHERE ptt.TranType IN ('ADJ-MTL','INS-MTL','STK-MTL')
		AND ptt.WarehouseCode NOT IN ('QA','QAP')
	GROUP BY
		ptt.PartNum,
		CAST(COALESCE(IIF(pt.[Part_FFS_Overide_c]='',NULL,IIF(pt.[Part_FFS_Overide_c]='UK','MfgSys',pt.Part_FFS_Overide_c)),
				 						 IIF(ct.[Customer_fulfilsite_c]='UK','MfgSys',ct.Customer_fulfilsite_c),
									 ptt.[Plant]) AS NVARCHAR(255)),
		ptt.TranDate,
		ptt.TranType


