
-- ===============================================================================
-- Author:      BF
-- Description: View to fetch Purchase Order Delivery for custom column PF-11
--
--  2025.01.06.BF Created
-- ===============================================================================


CREATE VIEW [bc_sql_cus].[v_CustomColumns_purchaseOrderDelivery]
AS

	SELECT
		aei.[itemNo] AS [itemNo],
		CAST(
			CASE 
				WHEN iex.[LSC Purch_ Order Delivery$5ecfc871-5d82-43f1-9c54-59685e82318d]=0 
				THEN 'Warehouse'
				ELSE
                'Store'
				END
				AS NVARCHAR(50)) AS [purchaseOrderDelivery]
	FROM dbo.[AGREssentials_items] aei
		INNER JOIN [bc_sql_cus].CustomColumns_ItemExt iex ON iex.No_=aei.itemNo


