

CREATE VIEW [cus].[v_STOCK_LEVEL_NESTED]
AS

    SELECT
        CAST(b.ItemCode AS NVARCHAR(255)) AS PRODUCT_ITEM_NO,
        CAST(b.WhsCode AS NVARCHAR(255)) AS LOCATION_NO,
        --CAST(ISNULL(b.ExpDate, '2100-01-01') AS DATE) AS EXPIRE_DATE,
        CAST(SUM(it.OnHand) AS DECIMAL(18,4)) AS STOCK_UNITS
    FROM
        [cus].OIBT b
		JOIN [cus].OITM it ON it.ItemCode = b.ItemCode
	WHERE
		b.Quantity > 0 AND ISNULL(b.ExpDate, '2100-01-01') >= CAST(GETDATE() AS DATE)
	GROUP BY
		b.ItemCode, b.WhsCode--, b.ExpDate--, b.BatchNum -- Batch numbers will be found in raw_cus.STOCK_BATCH_LEVEL


