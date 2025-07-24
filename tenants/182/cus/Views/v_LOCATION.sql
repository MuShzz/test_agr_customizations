
 CREATE VIEW [cus].[v_LOCATION] AS
       SELECT
            CAST(Location AS NVARCHAR(255)) AS [NO],
            CAST(Location AS NVARCHAR(255)) AS [NAME]
       FROM cus.StockLocation

