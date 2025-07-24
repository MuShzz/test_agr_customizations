
 CREATE VIEW [cus].[v_UNDELIVERED_PURCHASE_ORDER] AS
				 SELECT
				CAST(po.Number AS VARCHAR(128)) AS [PURCHASE_ORDER_NO],
				CAST(poi.[$Product.Code] AS NVARCHAR(255)) AS [ITEM_NO],
				CAST(po.[Branch.Code] AS NVARCHAR(255)) AS [LOCATION_NO],
				CAST(poi.[$DueDate] AS DATE) AS [DELIVERY_DATE],
				CAST(SUM(poi.[$Quantity]) AS DECIMAL(18, 4)) AS [QUANTITY]
		   FROM cus.PurchaseOrder po
		   LEFT JOIN cus.PurchaseOrderItems poi ON po.ID = poi.ID
		   WHERE po.[WorkflowStatus.Description] NOT IN ('Received','Written Off')
		   GROUP BY po.Number , poi.[$Product.Code],poi.[$DueDate], po.[Branch.Code]

