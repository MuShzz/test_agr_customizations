CREATE VIEW [visma_sql_cus].[v_ITEM_LOCATION] AS

-- Filtering duplicates by ranking them by who has ORIGINAL_NO	
WITH RankedIL AS (
	SELECT
		CAST(StcBal.ProdNo AS NVARCHAR(255)) AS [ITEM_NO],
		CAST(StcBal.StcNo AS NVARCHAR(255)) AS [LOCATION_NO],
		CAST(StcBal.MaxBal AS DECIMAL(18, 4)) AS [MAX_STOCK],
		CAST(0 AS BIT) AS [CLOSED_FOR_ORDERING],
		CAST(BuyAct.Nm AS NVARCHAR(255)) AS [RESPONSIBLE],
		CAST(Prod.Descr  AS NVARCHAR(255)) AS [NAME],
		CAST(Prod.Descr AS NVARCHAR(255)) AS [DESCRIPTION],
		CAST(IIF(StcBal.NrmSup = 0, NULL, StcBal.NrmSup) AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO],
		CAST(ISNULL(DelAlt.DelTm, s_purchase.settingValue) AS BIGINT) AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(ISNULL((DelAlt.AdmTm + DelAlt.TanspTm),s_transfer.settingValue) AS BIGINT) AS [TRANSFER_LEAD_TIME_DAYS],
		CAST(IIF(StcBal.PurcInt = 0, NULL, StcBal.PurcInt) AS SMALLINT) AS [ORDER_FREQUENCY_DAYS],
		CAST(NULL AS SMALLINT) AS [ORDER_COVERAGE_DAYS],
		CAST(SalePr.MinNo AS DECIMAL(18, 4)) AS [MIN_ORDER_QTY],
		CAST(DelAlt.SupProd AS NVARCHAR(50)) AS [ORIGINAL_NO],
		CAST(MIN (SalePr.SalePr) AS DECIMAL(18, 4)) AS [SALE_PRICE],
		CAST(StcBal.PhCstPr AS DECIMAL(18, 4)) AS [COST_PRICE],
		CAST(MAX (PurcPr.PurcPr - (PurcPr.PurcPr * ISNULL (PurcDcP.PurcDcP, 0)/100)) AS DECIMAL(18, 4)) AS [PURCHASE_PRICE],
		CAST(ISNULL(TRY_CAST(Prod.TrInf1 AS NUMERIC),1) AS DECIMAL(18,4)) AS [ORDER_MULTIPLE],
		CAST(ISNULL(TRY_CAST(Prod.Inf AS NUMERIC),0) AS DECIMAL(18,4)) AS [QTY_PALLET], 
		CAST(Prod.VolU/1000000 AS DECIMAL(18, 4)) AS [VOLUME],
		CAST(Prod.NWgtU/1000000 AS DECIMAL(18, 4)) AS [WEIGHT],
		CAST(StcBal.PurcPnt AS DECIMAL(18, 4)) AS [REORDER_POINT],
		CAST(0 AS BIT) AS [CLOSED],
		CAST(1 AS BIT) AS [INCLUDE_IN_AGR],
		CAST(StcBal.MinBal AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS],
		CAST(NULL AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK],
		CAST(0 AS BIT)   AS [SPECIAL_ORDER],
		ROW_NUMBER() OVER (
			PARTITION BY StcBal.ProdNo, StcBal.StcNo
			ORDER BY 
				CASE WHEN DelAlt.SupProd <> '' THEN 1 ELSE 2 END
		) AS [RANK]
	FROM
		[visma_sql].StcBal
		Left JOIN [visma_sql].Stc on Stc.StcNo = StcBal.StcNo
		Left JOIN [visma_sql_cus].Prod on Prod.ProdNo = StcBal.ProdNo
		Left JOIN [visma_sql].DelAlt on DelAlt.ProdNo = StcBal.ProdNo and DelAlt.SupNo = StcBal.NrmSup and StcBal.NrmSup > 0
		Left JOIN [visma_sql].Actor PurcAct on PurcAct.SupNo = StcBal.NrmSup and StcBal.NrmSup > 0
		Left JOIN [visma_sql].Actor BuyAct on BuyAct.EmpNo = Prod.Buyer and Prod.Buyer > 0
		Left JOIN [visma_sql].PrDcMat SalePr on SalePr.ProdNo = StcBal.ProdNo and SalePr.SalePr > 0 
							and (SalePr.FrDt = 0 or SalePr.FrDt <= (select CONVERT(INT, CONVERT(VARCHAR(8), GETDATE(), 112))))
							and (SalePr.ToDt = 0 or SalePr.ToDt >= (select CONVERT(INT, CONVERT(VARCHAR(8), GETDATE(), 112))))
							and SalePr.Cur = 0
							and SalePr.CustNo = 0
							and SalePr.EmpNo = 0
							and SalePr.ProdPrGr = 0
							and SalePr.CustPrGr = 0
		Left JOIN [visma_sql].PrDcMat PurcPr on PurcPr.ProdNo = StcBal.ProdNo and PurcPr.PurcPr > 0 
							and PurcPr.SupNo = StcBal.NrmSup
							and (PurcPr.FrDt = 0 or PurcPr.FrDt <= (select CONVERT(INT, CONVERT(VARCHAR(8), GETDATE(), 112))))
							and (PurcPr.ToDt = 0 or PurcPr.ToDt >= (select CONVERT(INT, CONVERT(VARCHAR(8), GETDATE(), 112))))
							and PurcPr.PurcCur = PurcAct.Cur
							and PurcPr.ProdPrGr = 0
							and PurcPr.CustPrGr = 0
		Left JOIN [visma_sql].PrDcMat PurcDcP on PurcDcP.ProdNo = Prod.ProdNo and PurcDcP.PurcDcP > 0 
							and PurcDcP.SupNo = StcBal.NrmSup
							and (PurcDcP.FrDt = 0 or PurcDcP.FrDt <= (select CONVERT(INT, CONVERT(VARCHAR(8), GETDATE(), 112))))
							and (PurcDcP.ToDt = 0 or PurcDcP.ToDt >= (select CONVERT(INT, CONVERT(VARCHAR(8), GETDATE(), 112))))
							and PurcDcP.ProdPrGr = 0
							and PurcDcP.CustPrGr = 0
		INNER JOIN core.setting s_purchase on s_purchase.settingKey = 'data_mapping_lead_times_purchase_order_lead_time'
		INNER JOIN core.setting s_transfer on s_transfer.settingKey = 'data_mapping_lead_times_transfer_order_lead_time'
		
	GROUP BY
		StcBal.ProdNo, StcBal.StcNo, StcBal.MinBal, StcBal.MaxBal, Prod.Gr3, BuyAct.Nm, Prod.Descr, 
		StcBal.NrmSup, DelAlt.AdmTm, DelAlt.ProdTm, DelAlt.DelTm, DelAlt.TanspTm, StcBal.PurcInt, 
		DelAlt.EcPurcQt, DelAlt.SupProd, StcBal.PhCstPr,  Prod.Inf, Prod.Inf5, Prod.VolU,	Prod.NWgtU, StcBal.PurcPnt, Prod.TrInf1, SalePr.MinNo,s_purchase.settingValue,s_transfer.settingValue
	)
	SELECT 
    [ITEM_NO],
	[LOCATION_NO],
    [SAFETY_STOCK_UNITS],
    [MIN_DISPLAY_STOCK],
    [MAX_STOCK],
	[CLOSED],
    [CLOSED_FOR_ORDERING],
    [RESPONSIBLE],
	[NAME],
    [DESCRIPTION],
    [PRIMARY_VENDOR_NO],
	[PURCHASE_LEAD_TIME_DAYS],
    [TRANSFER_LEAD_TIME_DAYS],
    [ORDER_FREQUENCY_DAYS],
    [ORDER_COVERAGE_DAYS],
    [MIN_ORDER_QTY],
    [ORIGINAL_NO],
    [SALE_PRICE],
    [COST_PRICE],
    [PURCHASE_PRICE],
    [ORDER_MULTIPLE],
    [QTY_PALLET],
    [VOLUME],
    [WEIGHT],
    [REORDER_POINT],
    [SPECIAL_ORDER],
    [INCLUDE_IN_AGR]
FROM RankedIL
WHERE [RANK] = 1

