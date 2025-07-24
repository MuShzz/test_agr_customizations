




-- ===============================================================================
-- Author:      Paulo Marques
-- Description: Stock history mapping from raw to adi
--
--  24.09.2024.TO   Altered
-- ===============================================================================


CREATE VIEW [cus].[v_STOCK_HISTORY] AS
       SELECT
            CAST(NULL AS BIGINT)														AS [TRANSACTION_ID],
            CAST(ptt.[PartNum] AS NVARCHAR(255)) 										AS [ITEM_NO],
            CAST(COALESCE(IIF(pt.[Part_FFS_Overide_c]='',NULL,IIF(pt.[Part_FFS_Overide_c]='UK','MfgSys',pt.Part_FFS_Overide_c)),
			 					 IIF(ct.[Customer_fulfilsite_c]='UK','MfgSys',ct.Customer_fulfilsite_c),
			 					 ptt.[Plant]) AS NVARCHAR(255))							AS [LOCATION_NO],
            CAST(ptt.[TranDate]  AS DATE) 												AS [DATE],
			CAST( 
				SUM(IIF(ptt.TranType LIKE '%-STK', ptt.ActTranQty, 0)) 
				+ 
				SUM(IIF(ptt.TranType LIKE 'STK-%', -ptt.ActTranQty, 0))
				+
				SUM(IIF(ptt.TranType = 'ADJ-QTY', ptt.ActTranQty, 0))
				AS DECIMAL(18,4))														AS [STOCK_MOVE],
            CAST(NULL AS DECIMAL(18, 4)) 												AS [STOCK_LEVEL]
       FROM cus.PartTran ptt
			LEFT JOIN cus.Part pt		ON ptt.[PartNum] = pt.[PartNum]
			LEFT JOIN cus.Customer ct	ON ptt.[CustNum] = ct.CustNum
	    WHERE (ptt.TranType LIKE '%-STK' OR  ptt.TranType LIKE 'STK-%' OR ptt.TranType = 'ADJ-QTY')
		AND ptt.WareHouseCode NOT IN ('QA','QAP')
		GROUP BY
        ptt.PartNum,
		CAST(COALESCE(IIF(pt.[Part_FFS_Overide_c]='',NULL,IIF(pt.[Part_FFS_Overide_c]='UK','MfgSys',pt.Part_FFS_Overide_c)),
					 					 IIF(ct.[Customer_fulfilsite_c]='UK','MfgSys',ct.Customer_fulfilsite_c),
					 					 ptt.[Plant]) AS NVARCHAR(255)),
		ptt.TranDate,
		ptt.TranType
		


