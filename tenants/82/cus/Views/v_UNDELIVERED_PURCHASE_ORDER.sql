

-- ===============================================================================
-- Author:      José Sucena
-- Description: UNDELIVERED_PURCHASE_ORDER Data mapping from CUS
--
--  23.09.2024.HMH   Created
-- ===============================================================================

CREATE VIEW [cus].[v_UNDELIVERED_PURCHASE_ORDER] 
AS

       SELECT
            CAST(p.PURCHID AS VARCHAR(128)) AS [PURCHASE_ORDER_NO],
            CAST(p.ITEMID AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(id.INVENTLOCATIONID AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(CASE p.CONFIRMEDDLV WHEN '1900-01-01 00:00:00.0000000' THEN p.DELIVERYDATE ELSE p.CONFIRMEDDLV END AS DATE) AS [DELIVERY_DATE],
            SUM(CAST(p.REMAINPURCHPHYSICAL AS DECIMAL(18,4))) AS [QUANTITY]
       FROM [cus].PURCHLINE p
		INNER JOIN [cus].INVENTDIM id ON id.INVENTDIMID = p.INVENTDIMID --AND id.DATAAREAID = p.DATAAREAID AND id.PARTITION = p.PARTITION
	   WHERE	
		--(CAST(p.PurchStatus AS DECIMAL(18,4)) = 0 OR CAST(p.PurchStatus AS DECIMAL(18,4)) = 1) 
		--AND 
		CAST(p.RemainPurchPhysical AS DECIMAL(18,4)) > 0
        --AND p.dataareaid = 'rar'
		--AND p.ITEMID = '2001204'
		--Rosendahl specific AND id.DATAAREAID='rdg'
	   GROUP BY p.PURCHID, p.ITEMID, id.INVENTLOCATIONID, CASE p.CONFIRMEDDLV WHEN '1900-01-01 00:00:00.0000000' THEN p.DELIVERYDATE ELSE p.CONFIRMEDDLV END


