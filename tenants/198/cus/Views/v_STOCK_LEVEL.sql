CREATE VIEW [cus].v_STOCK_LEVEL
             AS
            SELECT
        [Material] AS ITEM_NO,
        [plant] AS LOCATION_NO,
        CAST('2100-01-01' AS DATE) AS EXPIRE_DATE,
        SUM(CAST([MatlWrhsStkQtyInMatlBaseUnit] AS DECIMAL(18,4))) AS STOCK_UNITS
		--select top 100 *  
    FROM
         [cus].[MaterialStock]
		 WHERE StorageLocation IN ('1002','0001')
		 --AND Material='64218'
		 GROUP BY material, plant

