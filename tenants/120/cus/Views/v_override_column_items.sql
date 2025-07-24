







-- ===============================================================================
-- Author:      VR
-- Description: Placeholder for override items (api/RawData/items).
--				If you have a mix of overrides for different item sets, make sure the view covers all items.  Comment out fields that are not overwritten.
--				NULLs are okay and will not overwrite anything unless populated by a value.  This means that a payload like below is acceptable:
--				[no],	[weight],	[qtyPallet]
--				1-A		0.1			NULL
--				2-B		NULL		20
--
--				Weight for item 1-A will be overwritten but its the qtyPallet will be left alone.  Vice versa for item 2-B.
--
--  2024-03-12: VR Created
-- ===============================================================================
CREATE VIEW [cus].[v_override_column_items]
AS
	SELECT i.[ItemCode] AS [no]
	,CAST(NULL AS DECIMAL(18,4)) AS [volume] 
	,CAST(NULL AS DECIMAL(18,4)) AS [weight]
	,CAST(NULL AS DECIMAL(18,4)) AS [qtyPallet]
	,CAST(NULL AS DECIMAL(18,4)) AS [orderMultiple]
	,CAST(NULL AS INT) AS [leadTimeDays]
	,CAST(IIF([U_BeSpoke]='Y', 1, 0) AS BIT) AS [specialOrder] --IIF(NULL=1, 'true', 'false') AS [specialOrder]
	,NULL AS [excludeFromAgr] --IIF(NULL=1, 'true', 'false') AS [excludeFromAgr]
	
	FROM [cus].[OverrideRawData_Item] i

