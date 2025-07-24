CREATE VIEW [cus].v_STOCK_LEVEL
AS
SELECT CAST(itemId AS nvarchar(255))                             AS [ITEM_NO],
       CAST(ISNULL(lm.SAGE_LOCATION, mp.locId) AS nvarchar(255)) AS [LOCATION_NO],
       CAST('2100-01-01' AS date)                                AS [EXPIRE_DATE],
       CAST(qStk AS decimal(18, 4))                              AS [STOCK_UNITS]
FROM cus.MIILOC mp
         inner join cus.sage_misys_location_match lm on mp.locId = lm.MISYS_LOCATION and [stock_level] = 1
