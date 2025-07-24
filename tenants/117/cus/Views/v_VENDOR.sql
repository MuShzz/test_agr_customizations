 CREATE VIEW [cus].[v_VENDOR] AS
       SELECT
            CAST(vd.[VendorID] AS NVARCHAR(255)) AS [NO],
            CAST(vd.[Name] AS NVARCHAR(255)) AS [NAME],
            CAST(1 AS SMALLINT) AS [LEAD_TIME_DAYS],
            CAST(0 AS BIT) AS [CLOSED]
       FROM cus.Vendor vd
