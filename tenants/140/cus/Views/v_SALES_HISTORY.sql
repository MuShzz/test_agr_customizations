CREATE VIEW [cus].[v_SALES_HISTORY]
AS
WITH CTE AS (
    SELECT
				CAST(RANK() OVER( PARTITION BY S303.DEX_ROW_ID, S303.ITEMNMBR, S303.LOCNCODE, IIF(S303.SOPTYPE = '3', S303.ACTLSHIP, S303.ReqShipDate),IIF(S303.SOPTYPE = '3', S303.QTYFULFI, -S303.QTYFULFI), S303.SOPNUMBE, S302.VOIDSTTS ORDER BY S303.DEX_ROW_ID, S303.ITEMNMBR, S303.LOCNCODE, IIF(S303.SOPTYPE = '3', S303.ACTLSHIP, S303.ReqShipDate),IIF(S303.SOPTYPE = '3', S303.QTYFULFI, -S303.QTYFULFI), S302.CUSTNMBR, S303.SOPNUMBE, S302.VOIDSTTS) AS BIGINT) AS RANKING,
				CAST(ROW_NUMBER() OVER( ORDER BY S303.DEX_ROW_ID, S303.ITEMNMBR, S303.LOCNCODE, IIF(S303.SOPTYPE = '3', S303.ACTLSHIP, S303.ReqShipDate),IIF(S303.SOPTYPE = '3', S303.QTYFULFI, -S303.QTYFULFI), S302.CUSTNMBR, S303.SOPNUMBE, S302.VOIDSTTS) AS BIGINT) AS TRANSACTION_ID,
				CAST(S303.DEX_ROW_ID AS BIGINT) AS [ID],
				CAST(CONCAT(RTRIM(S303.ITEMNMBR), ' - ', S303.[Company]) AS NVARCHAR(255))    AS [ITEM_NO],
				CAST(S303.LOCNCODE AS NVARCHAR(255))    AS [LOCATION_NO],
				CAST(IIF(S303.SOPTYPE = '3', S303.ACTLSHIP, S303.ReqShipDate) AS DATE) AS [DATE],
				CAST(IIF(S303.SOPTYPE = '3', S303.QTYFULFI, -S303.QTYFULFI) AS DECIMAL(18,4))  AS [SALE],
				CAST(S302.CUSTNMBR AS NVARCHAR(255))    AS [CUSTOMER_NO],
				CAST(S303.SOPNUMBE AS NVARCHAR(255))    AS [REFERENCE_NO],
				CAST(S302.VOIDSTTS AS BIT)              AS [IS_EXCLUDED]
			FROM
				[cus].[SOP30300] S303
			LEFT JOIN
				[cus].[SOP30200] S302 ON S303.SOPNUMBE = S302.SOPNUMBE AND S303.SOPTYPE = S302.SOPTYPE
			WHERE
				S303.SOPTYPE IN ('3','4') AND S302.VOIDSTTS = '0'
)
SELECT
	[TRANSACTION_ID],
	[ITEM_NO],
	[LOCATION_NO],
	[DATE],
	[SALE],
	[CUSTOMER_NO],
	[REFERENCE_NO],
	[IS_EXCLUDED]
FROM CTE WHERE RANKING = '1'

