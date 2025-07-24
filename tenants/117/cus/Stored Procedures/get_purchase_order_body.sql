CREATE PROCEDURE [cus].[get_purchase_order_body]
(
    @OrderId INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    WITH order_to_transfer AS
	(
	SELECT 
		orderId AS orderId ,
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
                    'Our' AS QtyOption,
                    p.PUM,
                    p.IUM,
                    ott.CalcOurQTY,
                    ott.CalcVendQTY,
                    ott.DueDate
                FROM order_to_transfer ott
                JOIN cus.Part p ON ott.PartNum = p.PartNum
                FOR JSON PATH
            )
        FROM order_to_transfer ott
        JOIN cus.Vendor v ON v.vendorID = ott.vendorNo
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    ) AS order_body;
END

