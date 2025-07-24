

CREATE VIEW [bc_rest_cus].[v_cc_lastPurchasePrice]
AS

    WITH temp_ranked AS (
		  SELECT 
			   i.No,
			   ile.EntryNo,
			   ile.PostingDate,
			   ile.EntryType,
			   ile.SourceNo,
			   DENSE_RANK() OVER (PARTITION BY ile.ItemNo ORDER BY ile.PostingDate DESC) AS rn 
		  FROM 
		   bc_rest.item i 
		  INNER JOIN bc_rest.item_ledger_entry ile ON ile.ItemNo = i.No
		  INNER JOIN core.location_mapping_setup lms ON lms.locationNo=ile.LocationCode
		  WHERE ile.EntryType = 'Purchase'
		  ),
		 temp_with_rownum AS (
			SELECT *,
				   ROW_NUMBER() OVER (PARTITION BY No, rn ORDER BY EntryNo) AS row_num
			FROM temp_ranked
)
	SELECT DISTINCT
		t.No AS ITEM_NO,
		CAST(pp.DirectUnitCost AS DECIMAL(18,4)) AS lastPurchasePrice
	FROM temp_with_rownum t
	LEFT JOIN bc_rest.purch_price pp ON pp.ItemNo=t.No AND pp.VendorNo=t.SourceNo AND pp.StartingDate=t.PostingDate
	INNER JOIN adi.VENDOR v ON v.NO=t.SourceNo
	INNER JOIN adi.ITEM it ON it.NO=t.No AND it.PURCHASE_UNIT_OF_MEASURE=pp.UnitofMeasureCode
	WHERE t.rn=2 AND t.row_num = 1


