
-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: View to map 2 customer columns
--
-- 07.05.2025.BF    Created
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[v_cc_currency]
AS
 
		SELECT
			CAST(pp.ItemNo AS NVARCHAR(255)) AS ITEM_NO,
			CAST(IIF(pp.CurrencyCode='','SEK',pp.CurrencyCode) AS NVARCHAR(255)) AS currencycode,
			CAST(pp.DirectUnitCost AS [decimal](18, 4)) AS localCostPrice
		FROM
			[bc_rest].purch_price pp
		WHERE EndingDate > GETDATE() OR EndingDate ='0001-01-01'


