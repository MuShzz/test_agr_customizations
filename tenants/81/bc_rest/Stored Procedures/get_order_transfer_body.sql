



-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Get order transfer body for bc rest
--
-- 2024.10.30.TO   Created
-- 2025.04.30 DFS  Set location to NULL because of BC Setup at this tenant
-- ===============================================================================
CREATE PROCEDURE [bc_rest_cus].[get_order_transfer_body]
(
@OrderId INT = NULL
)
AS
BEGIN

	;WITH 
	order_to_transfer AS
	(
	SELECT 
		orderId		AS agrOrderId ,
		vendorNo	AS orderFromLocationNo ,
		'BLA'	AS orderToLocationNo ,
		CONCAT(CAST(estimatedDeliveryDate AS NVARCHAR), 'Z') AS estDelivDate,
		orderType	AS orderType,
		i.[No]		AS [itemNo],
		quantity	AS [qty] ,
		''			AS [style],
		''			AS [color],
		''			AS [size],
		i.[Code]	AS [variantCode]
		FROM dbo.order_transfer ot
  INNER JOIN (SELECT  
					 CAST(i.[No] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255)) AS [itemNo],
					 i.[No],
					 iv.[Code]
			    FROM [bc_rest].item i
		   LEFT JOIN [bc_rest].item_variant iv ON iv.[ItemNo] = i.[No]
		       UNION 
			  SELECT  
					 CAST(i.[No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255)) AS [itemNo],
					 i.[No_] AS [No],
					 iv.[Code]
			    FROM [bc_sql].Item i
		   LEFT JOIN [bc_sql].ItemVariant iv ON iv.[Item No_] = i.[No_]) i ON ot.itemNo = i.itemNo
		WHERE quantity > 0 AND orderId = @OrderId
	),
	order_lines AS
	(
	  SELECT (SELECT 
		[itemNo],
		[variantCode],
		[qty] ,
		[style],
		[color],
		[size],
		estDelivDate ,
		orderToLocationNo 
		FROM order_to_transfer
		ORDER BY [itemNo] 
		FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS lines_array
	),
	order_header AS
	(
	SELECT 
		agrOrderId ,
		orderFromLocationNo ,
		orderToLocationNo,  
		MIN(estDelivDate) AS estDelivDate ,
		orderType
	FROM order_to_transfer
	GROUP BY agrOrderId, orderFromLocationNo, orderToLocationNo,orderType
	)
	SELECT  
	(SELECT DISTINCT
		agrOrderId ,
		orderFromLocationNo ,
		orderToLocationNo, 
		estDelivDate ,
		orderType,
		agrLines = JSON_QUERY('[' + (SELECT lines_array FROM order_lines) + ']','$')
	FROM order_header
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS order_body


END

