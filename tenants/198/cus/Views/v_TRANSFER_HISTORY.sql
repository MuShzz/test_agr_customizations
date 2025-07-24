CREATE VIEW [cus].v_TRANSFER_HISTORY
             AS
WITH cte AS (
SELECT DISTINCT
Material,
Plant,
CAST(MatlWrhsStkQtyInMatlBaseUnit AS DECIMAL(18,4)) AS value
  FROM
        cus.UndeliveredPO_Shops
)
  
    SELECT DISTINCT
        CAST(NULL AS bigint) AS [TRANSACTION_ID],
        CAST([Material] AS NVARCHAR(255)) AS ITEM_NO,
		CAST('7901' AS NVARCHAR(255)) AS [FROM_LOCATION_NO],
        CAST(Plant AS NVARCHAR(255)) AS [TO_LOCATION_NO], 
		CAST(GETDATE() AS DATE) AS DATE,
        SUM(value )  AS [TRANSFER]
        
    FROM
        cte
		        
    GROUP BY
   PLANT, Material
