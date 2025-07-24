

CREATE VIEW [ogl_cus].[v_UNDELIVERED_TRANSFER_ORDER] AS

SELECT
          'TR-'+CAST(sdt.ref AS NVARCHAR(128))+'-'+CAST(sdt.intref AS NVARCHAR(128)) AS [TRANSFER_ORDER_NO],
          CAST(sdt.stcode AS NVARCHAR(255)) AS [ITEM_NO],
          CAST(sdt.depot2 AS NVARCHAR(255)) AS [LOCATION_NO],
          CAST(sdt.trdate AS DATE) AS [DELIVERY_DATE],
          SUM(CAST(sdt.quan AS DECIMAL(18,4)))  AS [QUANTITY],
          CAST(sdt.depot1 AS NVARCHAR(255)) AS [ORDER_FROM_LOCATION_NO]
      FROM [ogl_cus].[STDepotTransfers] sdt
      WHERE sdt.sqldeleteflag = 'N'
        AND sdt.quan > 0 
	  GROUP BY ('TR-'+CAST(sdt.ref AS NVARCHAR(128))+'-'+CAST(sdt.intref AS NVARCHAR(128))),
            CAST(sdt.stcode AS NVARCHAR(255)),
            CAST(sdt.depot2 AS NVARCHAR(255)),
            CAST(sdt.depot1 AS NVARCHAR(255)),
            CAST(sdt.trdate AS DATE)

