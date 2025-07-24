CREATE VIEW [cos_cus].[v_SALES_HISTORY]
 AS
	SELECT 
        ROW_NUMBER() OVER ( ORDER BY [DATE],[ITEM_NO],[LOCATION_NO] ASC)	AS [TRANSACTION_ID],
        CAST(ITEM_NO AS NVARCHAR(255))										AS [ITEM_NO],
        CAST(LOCATION_NO AS NVARCHAR(255))                  				AS [LOCATION_NO],
        CAST([DATE] AS DATE)                                				AS [DATE],
        CAST(ISNULL(SALE, 0) AS DECIMAL(18,4))              				AS [SALE],
        CAST(ISNULL(CUSTOMER_NO,'') AS NVARCHAR(255))       				AS [CUSTOMER_NO],
        CAST(ISNULL(REFERENCE_NO,'') AS NVARCHAR(255))      				AS [REFERENCE_NO],
        CAST(0 AS BIT)                                      				AS [IS_EXCLUDED]
    FROM
        [cos_cus].[AGR_SALES_HISTORY] 
