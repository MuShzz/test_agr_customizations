

CREATE PROCEDURE [cus].[get_ordertype_body]
(
@OrderId INT = NULL
)
AS
BEGIN
	SELECT 
    CAST(ot.orderType AS NVARCHAR(50) ) AS orderType
	FROM dbo.order_transfer ot
	WHERE orderId = @OrderId;

END

