
CREATE VIEW [cus].[v_OPEN_SALES_ORDER] AS
	SELECT
            CAST(soi.[_Owner_.Number] AS NVARCHAR(128)) AS [SALES_ORDER_NO],
            CAST(soi.[Product.Code] AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(soi.[_Owner_.Branch.Code] AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(SUM(soi.[QuantityOutstanding]) AS DECIMAL(18, 4)) AS [QUANTITY],
            CAST(soi.[_Owner_.Customer.Code] AS NVARCHAR(255)) AS [CUSTOMER_NO],
            CAST(soi.[_Owner_.DueDate] AS DATE) AS [DELIVERY_DATE]
       FROM  cus.SalesOrderLines soi
	   WHERE soi.[_Owner_.WorkflowStatus.Description] NOT IN ('Shipped','Written Off')
	   GROUP BY soi.[_Owner_.Number],soi.[Product.Code],soi.[_Owner_.Customer.Code],soi.[_Owner_.DueDate],soi.[_Owner_.Branch.Code]

