
CREATE VIEW [bc_rest_cus].[v_RecentLotNo] AS

	SELECT DISTINCT
		ItemNo, 
		LocationCode, 
		LotNo
	FROM [bc_rest].item_ledger_entry ile
	INNER JOIN bc_rest_cus.CC_ile cc ON cc.EntryNo=ile.EntryNo
	WHERE LotNo IS NOT NULL AND LotNo <> ''
	AND cc.[Open] = 1
	AND ExpirationDate <> '0001-01-01'


