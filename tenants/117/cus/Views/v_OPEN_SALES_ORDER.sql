
-- ===============================================================================
-- Author:      Paulo Marques
-- Description: open sales order mapping from raw to adi
--
--  24.09.2024.TO   Altered
-- ===============================================================================

CREATE VIEW [cus].[v_OPEN_SALES_ORDER] AS
       SELECT
            CAST(so.[OrderNum] AS NVARCHAR(128)) AS [SALES_ORDER_NO],
            CAST(sol.[PartNum] AS NVARCHAR(255)) AS [ITEM_NO],
			CAST(COALESCE(IIF(pt.[Part_FFS_Overide_c]='',NULL,IIF(pt.[Part_FFS_Overide_c]='UK','MfgSys',pt.Part_FFS_Overide_c)),
							 IIF(ct.[Customer_fulfilsite_c]='UK','MfgSys',ct.Customer_fulfilsite_c),
							 so.[Plant]) AS NVARCHAR(255)) AS LOCATION_NO,
            SUM(CAST((orl.SellingReqQty-orl.OurJobShippedQty) AS DECIMAL(18,4))) AS [QUANTITY],
            CAST(ct.[CustId] AS NVARCHAR(255)) AS [CUSTOMER_NO],
            CAST(orl.NeedByDate  AS DATE) AS [DELIVERY_DATE]
       FROM cus.[OrderHed] so
	INNER JOIN cus.[OrderDtl] sol ON so.[OrderNum] = sol.[OrderNum]
	INNER JOIN cus.OrderRel orl ON orl.OrderNum = so.OrderNum AND orl.OrderLine = sol.OrderLine
	LEFT JOIN cus.Part pt ON sol.[PartNum] = pt.[PartNum]
	LEFT JOIN cus.Customer ct ON so.CustNum = ct.CustNum
    WHERE orl.NeedByDate IS NOT NULL
	GROUP BY so.[OrderNum], sol.[PartNum], so.[Plant], orl.NeedByDate, ct.[CustID], pt.Part_FFS_Overide_c, ct.Customer_fulfilsite_c
	HAVING SUM(CAST((orl.SellingReqQty-orl.OurJobShippedQty) AS DECIMAL(18,4)))<>0


