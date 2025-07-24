






-- ===============================================================================
-- Author:      VR
-- Description: Placeholder for override vendors (api/RawData/vendors).
--				If you have a mix of overrides for different vendor sets, make sure the view covers all vendors.  Comment out fields that are not overwritten.
--				NULLs are okay and will not overwrite anything unless populated by a value.  This means that a payload like below is acceptable:
--				[no],	[weight],	[qtyPallet]
--				1-A		0.1			NULL
--				2-B		NULL		20
--
--				Weight for item 1-A will be overwritten but its the qtyPallet will be left alone.  Vice versa for item 2-B.
--
--  2024-03-12: VR Created
-- ===============================================================================
CREATE VIEW [cus].[v_override_column_vendors]
AS
	SELECT [ListId] AS [no],
       CustomFieldStandardLeadtimeDays AS [leadTimeDays], 
       NULL AS [excludeFromAgr] --IIF(NULL=1, 'true', 'false') AS [excludeFromAgr]
  FROM [cus].[CustomVendor]
 WHERE CustomFieldStandardLeadtimeDays IS NOT NULL AND CustomFieldStandardLeadtimeDays <> ''

