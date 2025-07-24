CREATE   VIEW [visma_sql_cus].[v_item] AS

WITH RankedItems AS (
    SELECT 
        CAST(Prod.ProdNo AS NVARCHAR(255)) AS [NO],
        CAST(Prod.Descr AS NVARCHAR(255)) AS [NAME],
        CAST(Prod.Descr AS NVARCHAR(255)) AS [DESCRIPTION],
		CAST(IIF(StcBal.NrmSup = 0, NULL, StcBal.NrmSup) AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO],
        CAST(ISNULL(DelAlt.DelTm, s_purchase.settingValue) AS BIGINT) AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(ISNULL((DelAlt.AdmTm +DelAlt.TanspTm),s_transfer.settingValue) AS BIGINT) AS [TRANSFER_LEAD_TIME_DAYS],
        CAST(IIF(StcBal.PurcInt = 0, NULL, StcBal.PurcInt) AS BIGINT) AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS BIGINT) AS [ORDER_COVERAGE_DAYS],
        CAST(ISNULL(SalePr.MinNo, 0) AS DECIMAL(18, 4)) AS [MIN_ORDER_QTY],
        CAST(DelAlt.SupProd AS NVARCHAR(50)) AS [ORIGINAL_NO],
        CAST(0 AS BIT) AS [CLOSED_FOR_ORDERING],
        CAST(BuyAct.Nm AS NVARCHAR(255)) AS [RESPONSIBLE],
        CAST(MIN(SalePr.SalePr) AS DECIMAL(18, 4)) AS [SALE_PRICE],
        CAST(StcBal.PhCstPr AS DECIMAL(18, 4)) AS [COST_PRICE],
        CAST(MAX(PurcPr.PurcPr - (PurcPr.PurcPr * ISNULL(PurcDcP.PurcDcP, 0)/100)) AS DECIMAL(18, 4)) AS [PURCHASE_PRICE],
        CAST(ISNULL(TRY_CAST(Prod.TrInf1 AS NUMERIC),1) AS DECIMAL(18,4)) AS [ORDER_MULTIPLE],
        CAST(ISNULL(TRY_CAST(Prod.Inf AS NUMERIC),0) AS DECIMAL(18,4)) AS [QTY_PALLET], 
		CAST(Prod.VolU/1000000 AS DECIMAL(18, 4)) AS [VOLUME],
		CAST(Prod.NWgtU/1000000 AS DECIMAL(18, 4)) AS [WEIGHT],
		CAST(StcBal.MinBal AS DECIMAL(18, 4)) AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18, 4)) AS [MIN_DISPLAY_STOCK],
        CAST(StcBal.MaxBal AS DECIMAL(18, 4)) AS [MAX_STOCK],
        CAST(Prod.ProdTp2 AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_1],
        CAST(Prod.Gr3 AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_2],
        CAST(Prod.ProdTp AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_3],
        CAST(SaleUn.Descr AS NVARCHAR(50)) AS [BASE_UNIT_OF_MEASURE],
        CAST(PurcUn.Descr AS NVARCHAR(50)) AS [PURCHASE_UNIT_OF_MEASURE],
		CAST(ISNULL(NULLIF(PurcUn.StUnRt, 0), 1) AS DECIMAL(18,4)) AS [QTY_PER_PURCHASE_UNIT],
        CAST(ISNULL(StcBal.PurcPnt, 0) AS DECIMAL(18, 4)) AS [REORDER_POINT],
        CAST(CASE WHEN Prod.Gr3 = 2 THEN 1 ELSE 0 END AS BIT) AS [SPECIAL_ORDER],
        CAST(1 AS BIT) AS [INCLUDE_IN_AGR],
        CAST(0 AS BIT) AS [CLOSED],
        ROW_NUMBER() OVER (PARTITION BY Prod.ProdNo ORDER BY CASE WHEN DelAlt.SupProd <> '' THEN 1 ELSE 2 END) AS [RANK]
    FROM
        [visma_sql_cus].Prod
        LEFT JOIN [visma_sql].StcBal ON StcBal.ProdNo = Prod.ProdNo AND StcBal.StcNo = Prod.NrmStc AND Prod.NrmStc > 0
        LEFT JOIN [visma_sql].DelAlt ON DelAlt.ProdNo = Prod.ProdNo AND DelAlt.SupNo = StcBal.NrmSup AND StcBal.NrmSup > 0
        LEFT JOIN [visma_sql].Actor SupAct ON SupAct.SupNo = StcBal.NrmSup AND StcBal.NrmSup > 0
        LEFT JOIN [visma_sql].Actor BuyAct ON BuyAct.EmpNo = Prod.Buyer AND Prod.Buyer > 0
        LEFT JOIN [visma_sql].PrDcMat SalePr ON SalePr.ProdNo = Prod.ProdNo AND SalePr.SalePr > 0 
                            AND (SalePr.FrDt = 0 OR SalePr.FrDt <= (SELECT CONVERT(INT, CONVERT(VARCHAR(8), GETDATE(), 112))))
                            AND (SalePr.ToDt = 0 OR SalePr.ToDt >= (SELECT CONVERT(INT, CONVERT(VARCHAR(8), GETDATE(), 112))))
                            AND SalePr.Cur = 0
                            AND SalePr.CustNo = 0
                            AND SalePr.EmpNo = 0
                            AND SalePr.ProdPrGr = 0
                            AND SalePr.CustPrGr = 0
        LEFT JOIN [visma_sql].PrDcMat PurcPr ON PurcPr.ProdNo = Prod.ProdNo AND PurcPr.PurcPr > 0 
                            AND PurcPr.SupNo = StcBal.NrmSup
                            AND (PurcPr.FrDt = 0 OR PurcPr.FrDt <= (SELECT CONVERT(INT, CONVERT(VARCHAR(8), GETDATE(), 112))))
                            AND (PurcPr.ToDt = 0 OR PurcPr.ToDt >= (SELECT CONVERT(INT, CONVERT(VARCHAR(8), GETDATE(), 112))))
                            AND PurcPr.PurcCur = SupAct.Cur
                            AND PurcPr.ProdPrGr = 0
                            AND PurcPr.CustPrGr = 0
        LEFT JOIN [visma_sql].PrDcMat PurcDcP ON PurcDcP.ProdNo = Prod.ProdNo AND PurcDcP.PurcDcP > 0 
                            AND PurcDcP.SupNo = StcBal.NrmSup
                            AND (PurcDcP.FrDt = 0 OR PurcDcP.FrDt <= (SELECT CONVERT(INT, CONVERT(VARCHAR(8), GETDATE(), 112))))
                            AND (PurcDcP.ToDt = 0 OR PurcDcP.ToDt >= (SELECT CONVERT(INT, CONVERT(VARCHAR(8), GETDATE(), 112))))
                            AND PurcDcP.ProdPrGr = 0
                            AND PurcDcP.CustPrGr = 0
        LEFT JOIN [visma_sql].Unit SaleUn ON SaleUn.Un = Prod.StSaleUn AND Prod.StSaleUn > 0
        LEFT JOIN [visma_sql].Unit PurcUn ON PurcUn.Un = DelAlt.StPurcUn AND DelAlt.StPurcUn > 0
        LEFT JOIN [visma_sql].Txt ProdPrG3Txt ON ProdPrG3Txt.Lang = 47 AND ProdPrG3Txt.TxtTp = 72 AND ProdPrG3Txt.TxtNo = Prod.ProdPrG3
        LEFT JOIN [visma_sql].Actor RespAct ON RespAct.EmpNo = Prod.Rsp AND Prod.Rsp > 0
        LEFT JOIN [visma_sql].Txt SupGrTxt ON SupGrTxt.Lang = 47 AND SupGrTxt.TxtTp = 77 AND SupGrTxt.TxtNo = SupAct.Gr10
		INNER JOIN core.setting s_purchase on s_purchase.settingKey = 'data_mapping_lead_times_purchase_order_lead_time'
		INNER JOIN core.setting s_transfer on s_transfer.settingKey = 'data_mapping_lead_times_transfer_order_lead_time'
		
		GROUP BY
    Prod.ProdNo, Prod.Descr, StcBal.NrmSup, DelAlt.AdmTm, DelAlt.ProdTm, DelAlt.DelTm, DelAlt.TanspTm, 
    StcBal.PurcInt, DelAlt.EcPurcQt, DelAlt.SupProd, Prod.Gr3, BuyAct.Nm, StcBal.PhCstPr, Prod.Inf, Prod.Inf5, Prod.VolU,
    Prod.NWgtU, StcBal.MinBal, StcBal.MaxBal, Prod.ProdTp2, Prod.ProdTp, SaleUn.Descr, PurcUn.Descr, PurcUn.StUnRt, StcBal.PurcPnt,
    Prod.NrmStc, ProdPrG3Txt.Txt, Prod.Inf8, RespAct.Nm, Prod.ExpStr, StcBal.InProd, StcBal.InProdO,
    StcBal.InProd, StcBal.Bal, StcBal.StcInc, SupGrTxt.Txt, Prod.Inf6, Prod.TrInf1, SalePr.MinNo,s_purchase.settingValue,s_transfer.settingValue

)
SELECT 
    [NO],
    [NAME],
    [DESCRIPTION],
    [PRIMARY_VENDOR_NO],
    [PURCHASE_LEAD_TIME_DAYS],
    [TRANSFER_LEAD_TIME_DAYS],
    [ORDER_FREQUENCY_DAYS],
    [ORDER_COVERAGE_DAYS],
    [MIN_ORDER_QTY],
    [ORIGINAL_NO],
    [CLOSED_FOR_ORDERING],
    [RESPONSIBLE],
    [SALE_PRICE],
    [COST_PRICE],
    [PURCHASE_PRICE],
    [ORDER_MULTIPLE],
    [QTY_PALLET],
    [VOLUME],
    [WEIGHT],
    [SAFETY_STOCK_UNITS],
    [MIN_DISPLAY_STOCK],
    [MAX_STOCK],
    [ITEM_GROUP_NO_LVL_1],
    [ITEM_GROUP_NO_LVL_2],
    [ITEM_GROUP_NO_LVL_3],
    [BASE_UNIT_OF_MEASURE],
    [PURCHASE_UNIT_OF_MEASURE],
    [QTY_PER_PURCHASE_UNIT],
    [REORDER_POINT],
    [SPECIAL_ORDER],
    [INCLUDE_IN_AGR],
    [CLOSED]
FROM RankedItems
WHERE [RankedItems].[RANK] = 1

