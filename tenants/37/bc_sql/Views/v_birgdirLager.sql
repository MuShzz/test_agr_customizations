



CREATE VIEW [bc_sql_cus].[v_birgdirLager] AS

	SELECT
		it.NO AS [Item No_],
		CAST(ISNULL(SUM([Quantity]),0) AS INT) AS [Quantity]
	FROM adi.ITEM it
	LEFT JOIN [bc_sql].[ItemLedgerEntry] ile ON ile.[Item No_]=it.NO AND ile.[Location Code] IN ('AVORUHUS','VORUHUS','LAGER','LESTIN')
	--WHERE it.NO='ZKIT-W10279256-ZKIT-W1027'
	GROUP BY it.NO

