



-- ===============================================================================
-- Author:      Paulo Marques
-- Description: Undelivered transfer order mapping from raw to adi
--
-- 24.09.2024.TO    Altered
-- ===============================================================================


CREATE VIEW [cus].[v_UNDELIVERED_TRANSFER_ORDER] AS
	SELECT
		CAST(CONCAT(tfo.[TFOrdNum],100000+tfo.[TFOrdLine]) AS VARCHAR(128)) AS [TRANSFER_ORDER_NO],
		CAST(tfo.[PartNum] AS NVARCHAR(255)) AS [ITEM_NO],
		CAST(tfo.[ToPlant] AS NVARCHAR(255)) AS [LOCATION_NO],
		CAST(tfo.[Plant] AS NVARCHAR(255)) AS [ORDER_FROM_LOCATION_NO],
		CAST(tfo.[NeedByDate] AS DATE) AS [DELIVERY_DATE],
		--CAST(SUM(CAST(tfo.[OurStockQty] AS DECIMAL(18,4))) AS DECIMAL(18, 4)) AS [QUANTITY],
		CAST(SUM(tfo.OurStockQty-tfo.ReceivedQty) AS DECIMAL(18, 4)) AS [QUANTITY]
	FROM cus.[TFOrdDtl] tfo
	WHERE tfo.TFOrdNum <> ''
	GROUP BY [TFOrdNum],[TFOrdLine],[PartNum],[ToPlant],[Plant],[NeedByDate]
	HAVING CAST(SUM(tfo.OurStockQty-tfo.ReceivedQty) AS DECIMAL(18, 4))>0



