




-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Visma SQL view for item locations
-- 19.11.2024.HMH   Created
-- ====================================================================================================


CREATE VIEW [visma_sql_cus].[v_ITEM_LOCATION] AS
	   
	SELECT
		CAST(StcBal.ProdNo AS NVARCHAR(255)) AS [ITEM_NO],
		CAST(StcBal.StcNo AS NVARCHAR(255)) AS [LOCATION_NO],
		CAST(StcBal.MaxBal AS DECIMAL(18, 4)) AS [MAX_STOCK],
		CAST(0 AS BIT) AS [CLOSED_FOR_ORDERING],
		CAST(BuyAct.Nm AS NVARCHAR(255)) AS [RESPONSIBLE],
		CAST(Prod.Descr  AS NVARCHAR(255)) AS [NAME],
		CAST(Prod.Descr AS NVARCHAR(255)) AS [DESCRIPTION],
		CAST(StcBal.NrmSup  AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO],
		CAST(ISNULL(DelAlt.AdmTm,0) + ISNULL(DelAlt.ProdTm,0) + ISNULL(DelAlt.DelTm,0)  AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS],
		CAST(ISNULL(DelAlt.AdmTm,0) + ISNULL(DelAlt.TanspTm,0) AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS],
		CAST(StcBal.PurcInt AS SMALLINT) AS [ORDER_FREQUENCY_DAYS],
		CAST(NULL AS SMALLINT) AS [ORDER_COVERAGE_DAYS],
		CAST(DelAlt.EcPurcQt AS DECIMAL(18, 4)) AS [MIN_ORDER_QTY],
		CAST(DelAlt.SupProd AS NVARCHAR(50)) AS [ORIGINAL_NO],
		CAST(MIN (SalePr.SalePr) AS DECIMAL(18, 4)) AS [SALE_PRICE],
		CAST(StcBal.PhCstPr AS DECIMAL(18, 4)) AS [COST_PRICE],
		CAST(MAX (PurcPr.PurcPr - (PurcPr.PurcPr * ISNULL (PurcDcP.PurcDcP, 0)/100)) AS DECIMAL(18, 4)) AS [PURCHASE_PRICE],
		CAST(CASE WHEN [visma_sql].UDF_ExtractNumbers (Prod.Inf) > '' THEN  [visma_sql].UDF_ExtractNumbers (Prod.Inf) ELSE 0 END AS DECIMAL(18, 4)) AS [ORDER_MULTIPLE],
		CAST(CASE WHEN [visma_sql].UDF_ExtractNumbers (Prod.Inf5) > '' THEN  [visma_sql].UDF_ExtractNumbers (Prod.Inf5) ELSE 0 END AS DECIMAL(18, 4)) AS [QTY_PALLET],
		CAST(Prod.VolU AS DECIMAL(18, 4)) AS [VOLUME],
		CAST(Prod.NWgtU AS DECIMAL(18, 4)) AS [WEIGHT],
		CAST(StcBal.PurcPnt AS DECIMAL(18, 4)) AS [REORDER_POINT],
		CAST(0 AS BIT) AS [CLOSED],
		CAST(1 AS BIT) AS [INCLUDE_IN_AGR],
		CAST(StcBal.MinBal AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK],
		CAST(NULL AS BIT)   AS [SPECIAL_ORDER]
	FROM
		[visma_sql].StcBal
		Left JOIN [visma_sql].Stc on Stc.StcNo = StcBal.StcNo
		Left JOIN [visma_sql].Prod on Prod.ProdNo = StcBal.ProdNo
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
	WHERE
		(Stc.Fax = 'ST' or Stc.Fax = 'WH') and StcBal.StcNo = Prod.NrmStc  AND 1=0
	GROUP BY
		StcBal.ProdNo, StcBal.StcNo, StcBal.MinBal, StcBal.MaxBal, Prod.Gr3, BuyAct.Nm, Prod.Descr, 
		StcBal.NrmSup, DelAlt.AdmTm, DelAlt.ProdTm, DelAlt.DelTm, DelAlt.TanspTm, StcBal.PurcInt, 
		DelAlt.EcPurcQt, DelAlt.SupProd, StcBal.PhCstPr,  Prod.Inf, Prod.Inf5, Prod.VolU,	Prod.NWgtU, StcBal.PurcPnt

