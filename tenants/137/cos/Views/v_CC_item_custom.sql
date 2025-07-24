
CREATE VIEW [cos_cus].[v_CC_item_custom]
AS

SELECT
	CAST(aic.NO AS NVARCHAR(255)) AS item_no,
	CAST(aic.EAN AS NVARCHAR(255)) AS ean,
	CAST(aic.DATE_AVAILABLE AS DATE) AS dateAvailable,
	CAST(IIF( aic.IS_BACKORDER='True', 1, 0) AS bit) AS isBackorder
FROM cos_cus.AGR_ITEM_CUSTOM aic


