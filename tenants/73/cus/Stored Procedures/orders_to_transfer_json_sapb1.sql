

CREATE PROCEDURE [cus].[orders_to_transfer_json_sapb1]
@orderId INT
AS
BEGIN
    SET NOCOUNT ON
    DROP TABLE IF EXISTS #orders
    CREATE TABLE #orders (order_id INT PRIMARY KEY, order_type NVARCHAR(20), order_from_location_no NVARCHAR(255), order_to_location_no NVARCHAR(255), order_date DATETIME2(0), estimatedDeliveryDate DATE, Currency NVARCHAR(10), SalesPerson NVARCHAR(100))

    DROP TABLE IF EXISTS #order_lines
    CREATE TABLE #order_lines (order_id INT, item_no NVARCHAR(255), unit_qty_chg DECIMAL(18,4), order_to_location_no NVARCHAR(255), TaxCode NVARCHAR(255), UnitPrice NVARCHAR(255))
    CREATE CLUSTERED INDEX #ix_order_lines ON #order_lines (order_id, item_no)

    INSERT INTO #orders (order_id, order_type, order_from_location_no, estimatedDeliveryDate, Currency, SalesPerson)
         SELECT DISTINCT ot.orderId, ot.orderType, ot.vendorNo, CAST(ot.estimatedDeliveryDate AS DATE), COALESCE(v.Currency, 'GBP'), CAST(v.SlpCode AS NVARCHAR(100))
           FROM dbo.order_transfer ot
		   LEFT JOIN cus.OCRD v ON v.CardCode = ot.vendorNo
          WHERE orderType IN ('purchase', 'transfer') AND orderId = @orderId
          ORDER BY 1

    UPDATE x SET x.order_date = o.createdAt
      FROM #orders x
        LEFT JOIN dbo.order_transfer o ON o.orderId = x.order_id

    INSERT INTO #order_lines (order_id, item_no, unit_qty_chg, order_to_location_no, TaxCode, UnitPrice)
         SELECT ot.orderId, ot.itemNo, ot.quantityInPurchaseUnits, CASE WHEN i.DfltWH IS NOT NULL THEN i.DfltWH ELSE TRIM(ot.locationNo) END, i.VatGourpSa, (ot.quantity/ot.quantityInPurchaseUnits)*ii.Price
           FROM dbo.order_transfer ot
		   INNER JOIN cus.OITM i ON i.ItemCode = ot.itemNo
		   INNER JOIN cus.ITM1 ii ON ii.ItemCode = ot.itemNo AND ii.PriceList = 2
          WHERE ot.orderType IN ('purchase', 'transfer') AND ot.quantity>0
          ORDER BY 1, 2


    DECLARE @order_id INT, @order_type NVARCHAR(20), @order_from_location_no NVARCHAR(255), @json NVARCHAR(MAX), @description NVARCHAR(3000)

    DECLARE @orders_json TABLE (order_id INT PRIMARY KEY, order_type NVARCHAR(20), order_json NVARCHAR(MAX), [description] NVARCHAR(3000))

    DECLARE @cursor CURSOR
    SET @cursor = CURSOR LOCAL FAST_FORWARD
        FOR SELECT order_id, order_type, order_from_location_no FROM #orders ORDER BY 1
    OPEN @cursor
    FETCH NEXT FROM @cursor INTO @order_id, @order_type, @order_from_location_no
    WHILE @@FETCH_STATUS = 0
    BEGIN

            SET @json = (SELECT
							o.order_from_location_no AS CardCode,
							'22' AS DocObjectCode, --22 = Purchase Order
							o.estimatedDeliveryDate AS DocDueDate,
							o.CUrrency AS Currency,
							o.SalesPerson AS SalesPersonCode,

							DocumentLines.item_no AS ItemCode,
							DocumentLines.unit_qty_chg AS Quantity,
							DocumentLines.TaxCode AS TaxCode,
							DocumentLines.UnitPrice AS UnitPrice,
							DocumentLines.order_to_location_no AS WarehouseCode,
			                DocumentLines.[UoMCode] AS UoMCode
                         FROM
                             #orders o
                             INNER JOIN (SELECT ol.order_id,
                                                ol.item_no,
                                                ol.unit_qty_chg,   
                                                ol.TaxCode,
                                                ol.UnitPrice,
                                                ol.order_to_location_no,
                                                (SELECT MIN([BuyUnitMsr]) FROM cus.OITM WHERE itemcode = ol.item_no) AS [UoMCode] 
                                           FROM #order_lines ol
                                          WHERE ol.order_id = @orderId) DocumentLines ON DocumentLines.order_id = o.order_id
                         WHERE
                             o.order_id = @order_id
                         FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER)
			SET @description = ''


        INSERT INTO @orders_json (order_id, order_type, order_json, [description]) VALUES (@order_id, @order_type, @json, @description)

        FETCH NEXT FROM @cursor INTO @order_id, @order_type, @order_from_location_no
    END
    CLOSE @cursor
    DEALLOCATE @cursor

    SELECT order_id, order_type, order_json, [description] FROM @orders_json ORDER BY order_id
END

