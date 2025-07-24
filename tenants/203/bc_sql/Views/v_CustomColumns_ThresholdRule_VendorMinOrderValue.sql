
CREATE VIEW bc_sql_cus.v_CustomColumns_ThresholdRule_VendorMinOrderValue
as

	SELECT
		   aei.[itemNo] as [itemNo]
		  ,CAST(CAST(tr.[Minimum Value] AS DECIMAL(18,6)) AS NVARCHAR(255)) AS [Minimum Value]
	FROM dbo.[AGREssentials_items] aei
		INNER JOIN adi.ITEM it ON it.NO = aei.itemNo
		INNER JOIN bc_sql_cus.CustomColumns_ThresholdRule tr ON it.PRIMARY_VENDOR_NO = tr.[Source No_] AND tr.[Threshold Field] = 1 AND tr.[Type] = 0


