
CREATE VIEW [bc_rest_cus].[v_ExpirationDate] AS

	SELECT DISTINCT
		ile.ItemNo, 
		ile.LocationCode, 
		CAST(ile.ExpirationDate AS DATE) AS ExpirationDate
	FROM bc_rest.item_ledger_entry ile
	INNER JOIN bc_rest_cus.CC_ile cc ON cc.EntryNo = ile.EntryNo
	WHERE ile.LotNo IS NOT NULL AND ile.LotNo <> ''
	AND cc.[Open] = 1
	AND ile.ExpirationDate <> '0001-01-01'

