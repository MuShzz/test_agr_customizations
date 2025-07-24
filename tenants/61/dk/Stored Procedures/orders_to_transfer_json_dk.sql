




CREATE PROCEDURE [dk_cus].[orders_to_transfer_json_dk]
@orderId INT
AS
BEGIN
    SET NOCOUNT ON
    SET NOCOUNT ON

    DROP TABLE IF EXISTS #orders
    CREATE TABLE #orders (order_id INT PRIMARY KEY, order_type NVARCHAR(20), order_from_location_no NVARCHAR(255), order_date DATETIME2(0), estimatedDeliveryDate DATETIME2(0))

    DROP TABLE IF EXISTS #order_lines
    CREATE TABLE #order_lines (order_id INT, item_no NVARCHAR(255), unit_qty_chg DECIMAL(18,4), order_to_location_no NVARCHAR(255))
    CREATE CLUSTERED INDEX #ix_order_lines ON #order_lines (order_id, item_no)

    INSERT INTO #orders (order_id, order_type, order_from_location_no, estimatedDeliveryDate)
         SELECT DISTINCT orderId, orderType, vendorNo, estimatedDeliveryDate
           FROM dbo.order_transfer
          WHERE orderType IN ('purchase', 'transfer') AND orderId = @orderId
          ORDER BY 1

    UPDATE x SET x.order_date = (select convert(varchar, getdate(), 126))
      FROM #orders x
        LEFT JOIN dbo.order_transfer o ON o.orderId = x.order_id

    INSERT INTO #order_lines (order_id, item_no, unit_qty_chg, order_to_location_no)
         SELECT orderId, itemNo, quantity, LocationNo
           FROM dbo.order_transfer
          WHERE orderType IN ('purchase', 'transfer') AND quantity <> 0
          ORDER BY 1, 2

    DECLARE @order_id INT, @order_type NVARCHAR(20), @order_from_location_no NVARCHAR(255), @json NVARCHAR(MAX), @description nvarchar(3000), @order_RequestedDate DATETIME2(0)

    DECLARE @orders_json TABLE (order_id INT PRIMARY KEY, order_type NVARCHAR(20), order_json NVARCHAR(MAX), [description] NVARCHAR(3000))

    DECLARE @cursor CURSOR
    SET @cursor = CURSOR LOCAL FAST_FORWARD
        FOR SELECT order_id, order_type, order_from_location_no, estimatedDeliveryDate FROM #orders ORDER BY 1
    OPEN @cursor
    FETCH NEXT FROM @cursor INTO @order_id, @order_type, @order_from_location_no, @order_RequestedDate
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @order_type = 'purchase'
        BEGIN
            SET @json = (SELECT
                             Id = 0,
                             Number = '',
                             Reference = CONVERT(VARCHAR, o.order_id),
                             OrderDate = o.order_date,
                             Vendor = JSON_QUERY((SELECT Number = @order_from_location_no FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)),
                             Arrival = JSON_QUERY((SELECT RequestedDate = CONVERT(VARCHAR, @order_RequestedDate, 126) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)),
                             Warehouse = Lines.order_to_location_no,
                             Code = item_no,
                             CodeType = 'ItemCode',
                             Quantity = Lines.unit_qty_chg,
                             Id = 0
                         FROM
                             #orders o
                             INNER JOIN #order_lines Lines ON Lines.order_id = o.order_id
                         WHERE
                             o.order_id = @order_id
                         FOR JSON AUTO)
			SET @description = ''
        END
        ELSE IF @order_type = 'transfer'
        BEGIN
            SET @json = (SELECT
                             ItemCode = item_no,
                             [From] = @order_from_location_no,
                             [To] = order_to_location_no,
                             Comment = ''+CAST(@order_id AS NVARCHAR(10)),
                             Quantity = unit_qty_chg
                         FROM
                             #order_lines
                         WHERE
                             order_id = @order_id
                         FOR JSON AUTO)
			SET @description = @order_from_location_no + '->' + (SELECT TOP 1 order_to_location_no FROM #order_lines) + ' - AGR'
        END

        INSERT INTO @orders_json (order_id, order_type, order_json, [description]) VALUES (@order_id, @order_type, @json, @description)

        FETCH NEXT FROM @cursor INTO @order_id, @order_type, @order_from_location_no, @order_RequestedDate
    END
    CLOSE @cursor
    DEALLOCATE @cursor

    SELECT order_id, order_type, order_json, [description], @order_RequestedDate AS [requestedDate] FROM @orders_json ORDER BY order_id
END


