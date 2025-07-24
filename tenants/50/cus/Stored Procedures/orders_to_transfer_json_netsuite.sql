

CREATE PROCEDURE [cus].[orders_to_transfer_json_netsuite]
@orderId INT
AS
BEGIN
    SET NOCOUNT ON
    SET NOCOUNT ON
	--DECLARE @orderId INT = 647

    DROP TABLE IF EXISTS #orders
    CREATE TABLE #orders (order_id INT PRIMARY KEY, order_type NVARCHAR(20), order_from_location_no NVARCHAR(255), order_date DATETIME2(0), estimatedDeliveryDate DATE, load_port NVARCHAR(64), shipDate DATE)

    DROP TABLE IF EXISTS #order_lines
    CREATE TABLE #order_lines (order_id INT, item_no NVARCHAR(255), unit_qty_chg DECIMAL(18,4), order_to_location_no NVARCHAR(255), expectedDeliveryDateOrderLine DATE, ActualShipDate DATE)
    CREATE CLUSTERED INDEX #ix_order_lines ON #order_lines (order_id, item_no)

    INSERT INTO #orders (order_id, order_type, order_from_location_no, estimatedDeliveryDate, load_port, shipDate)
	SELECT DISTINCT o.orderId, o.orderType, ve.id AS vendorNo, o.estimatedDeliveryDate, lp.[Internal ID] AS load_port, DATEADD(day, -CAST(lp.[Load Port Lead Time] AS INT), o.[estimatedDeliveryDate]) AS 'shipDate'
	FROM dbo.order_transfer o
	LEFT JOIN cus.Vendor ve ON o.vendorNo = CAST(ve.entityid AS NVARCHAR(128))
	LEFT JOIN cus.CustomColumns_Item cc ON o.itemNo = cc.itemid
	LEFT JOIN cus.LoadPort lp ON cc.load_port = lp.Name -- Adjust this join condition based on actual column names
	WHERE o.orderType IN ('purchase') AND quantity <> 0 AND o.orderId = @orderId
	GROUP BY o.orderId, o.orderType, ve.id, o.estimatedDeliveryDate, lp.[Internal ID], lp.[Load Port Lead Time]
	ORDER BY o.orderId;

    UPDATE x SET x.order_date = o.createdAt
      FROM #orders x
        LEFT JOIN dbo.order_transfer o ON o.orderId = x.order_id

    INSERT INTO #order_lines (order_id, item_no, unit_qty_chg, order_to_location_no, expectedDeliveryDateOrderLine, ActualShipDate)
         SELECT orderId, it.id AS itemNo, quantity, LocationNo, estimatedDeliveryDateOrderLine, DATEADD(day, -CAST(lp.[Load Port Lead Time] AS INT), o.[estimatedDeliveryDate]) AS 'custcol_hh_actual_shipping_date'
           FROM dbo.order_transfer o
		   LEFT JOIN cus.Item it ON o.itemNo = CAST(it.itemid AS NVARCHAR(128))
		   LEFT JOIN cus.Vendor ve ON o.vendorNo = CAST(ve.entityid AS NVARCHAR(128))
		   LEFT JOIN cus.CustomColumns_Item cc ON o.itemNo = cc.itemid
		   LEFT JOIN cus.LoadPort lp ON cc.load_port = lp.Name
          WHERE orderType IN ('purchase') AND quantity <> 0
          ORDER BY 1, 2

    DECLARE @order_id INT, @order_type NVARCHAR(20), @order_from_location_no NVARCHAR(255), @json NVARCHAR(MAX), @description nvarchar(3000)

    DECLARE @orders_json TABLE (order_id INT PRIMARY KEY, order_type NVARCHAR(20), order_json NVARCHAR(MAX), [description] NVARCHAR(3000))

    DECLARE @cursor CURSOR
    SET @cursor = CURSOR LOCAL FAST_FORWARD
        FOR SELECT order_id, order_type, order_from_location_no FROM #orders ORDER BY 1
    OPEN @cursor
    FETCH NEXT FROM @cursor INTO @order_id, @order_type, @order_from_location_no
    WHILE @@FETCH_STATUS = 0
    BEGIN
 SET @json = (
        SELECT
            entity = JSON_QUERY((SELECT id = o.order_from_location_no FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)),
            email = 'agr@agrdynamics.com',
			custbody_hh_provisional = CAST(1 AS bit),
			custbody_hh_load_port = CAST(o.load_port AS int),			custbody_hh_receive_by = o.estimatedDeliveryDate,
			shipDate = o.shipDate,
            item = JSON_QUERY((
                SELECT
                    items = (
                        SELECT
                            item = JSON_QUERY((SELECT id = Lines.item_no FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)),
                            quantity = Lines.unit_qty_chg,
                            custcol_expected_receipt_date = Lines.expectedDeliveryDateOrderLine,
                            custcol_hh_actual_shipping_date = Lines.ActualShipDate
                        FROM
                            #order_lines Lines
                        WHERE
                            Lines.order_id = o.order_id
                        FOR JSON PATH
                    )
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            ))
        FROM
            #orders o
        WHERE
            o.order_id = @order_id
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )
		SET @description = ''
        

        INSERT INTO @orders_json (order_id, order_type, order_json, [description]) VALUES (@order_id, @order_type, @json, @description)

        FETCH NEXT FROM @cursor INTO @order_id, @order_type, @order_from_location_no
    END
    CLOSE @cursor
    DEALLOCATE @cursor

    SELECT order_id, order_type, order_json, [description] FROM @orders_json ORDER BY order_id
END


