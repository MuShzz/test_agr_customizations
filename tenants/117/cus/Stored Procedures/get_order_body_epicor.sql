CREATE PROCEDURE [cus].[get_order_body_epicor]
(
    @OrderId INT = NULL,
	@OrderType NVARCHAR(50) = NULL
)
AS
	IF @OrderType = 'purchase'
	BEGIN
		WITH RankedVendParts AS 
			(SELECT *, ROW_NUMBER() OVER (PARTITION BY PartNum, VendorNum ORDER BY EffectiveDate DESC) AS RowNum FROM cus.VendPart),
		order_to_transfer AS
		(
			SELECT 
				orderId AS orderId ,
				ot.locationNo AS locationNo,
				vendorNo AS vendorNo,
				CAST(estimatedDeliveryDate AS DATE) AS DueDate,
				orderType AS orderType,
				itemNo AS PartNum,
				CAST(quantity AS DECIMAL(18,4)) AS CalcOurQTY,
				CAST(quantity AS DECIMAL(18,4)) AS CalcVendQTY
				FROM dbo.order_transfer ot
				WHERE quantity > 0 AND orderId = @OrderId
		)
			SELECT (
				
				SELECT DISTINCT
					v.VendorNum AS VendorNum,
					PODetails = (
						SELECT 
							ott.PartNum,
							vendp.VenPartNum,
							'Our' AS QtyOption,
							p.PUM,
							p.IUM,
							ott.CalcOurQTY,
							ott.CalcVendQTY,
							ott.DueDate
						 
						FROM order_to_transfer ott
						JOIN cus.Part p ON ott.PartNum = p.PartNum
						JOIN RankedVendParts vendp ON ott.PartNum = vendp.PartNum
						INNER JOIN cus.PartPlant pp ON vendp.PartNum = pp.PartNum AND vendp.VendorNum = pp.VendorNum
						WHERE ott.PartNum = vendp.PartNum AND ott.locationNo = pp.Plant AND RowNum = 1
						ORDER BY vendp.PartNum
						FOR JSON PATH
					)
				FROM order_to_transfer ott
				JOIN cus.Vendor v ON v.vendorID = ott.vendorNo
				FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
		) AS order_body;
	END
	ELSE IF @OrderType = 'transfer'
	BEGIN
		WITH 
			order_to_transfer AS
			(
			SELECT 
				orderId AS orderId,
				vendorNo AS Plant ,
				locationNo AS ToPlant,
				CAST(GETDATE() AS DATE) AS RequestDate,
				CAST(estimatedDeliveryDate AS DATE) AS NeedByDate,
				itemNo AS PartNum,
				CAST(quantity AS DECIMAL(18,4)) AS SellingQTY
				FROM dbo.order_transfer ot
				WHERE quantity > 0 AND orderId = @OrderId
			)
			SELECT  
			(SELECT 
				ShipViaCode = 'DEF',
				Plant,
				ToPlant,
				RequestDate,
				NeedByDate
			FROM order_to_transfer
			FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS order_body
		END

