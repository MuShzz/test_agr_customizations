-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Custom data
--
-- 2023.09.20.TO   Created
-- ===============================================================================
CREATE PROCEDURE [cus].[customise_orders](@order_id INT)
AS
BEGIN
    SET NOCOUNT ON


    UPDATE dbo.Orders
    SET status = 0
    WHERE [id] = @order_id;


    UPDATE dbo.Orders
    SET OrderFromlocationNo = CASE
                                WHEN OrderFromlocationNo LIKE '%-HYU-HYU'
                                    THEN REPLACE(OrderFromlocationNo, '-HYU-HYU', '-HYU')
                                WHEN OrderFromlocationNo LIKE '%-BLI-BLI'
                                    THEN REPLACE(OrderFromlocationNo, '-BLI-BLI', '-BLI')
                                WHEN OrderFromlocationNo LIKE '%-JLR-JLR'
                                    THEN REPLACE(OrderFromlocationNo, '-JLR-JLR', '-JLR')
                                ELSE REPLACE(
                                        REPLACE(
                                                REPLACE(
                                                        REPLACE(OrderFromlocationNo, '-BLI', ''),
                                                        '-JLR', ''),
                                                '-HYU', ''),
                                        '-HUY', '')
        END
    WHERE [id] = @order_id;




    UPDATE dbo.Orders
    SET OrderToLocationNo = CASE
                                WHEN OrderToLocationNo LIKE '%-HYU-HYU'
                                    THEN REPLACE(OrderToLocationNo, '-HYU-HYU', '-HYU')
                                WHEN OrderToLocationNo LIKE '%-BLI-BLI'
                                    THEN REPLACE(OrderToLocationNo, '-BLI-BLI', '-BLI')
                                WHEN OrderToLocationNo LIKE '%-JLR-JLR'
                                    THEN REPLACE(OrderToLocationNo, '-JLR-JLR', '-JLR')
                                ELSE REPLACE(
                                        REPLACE(
                                                REPLACE(
                                                        REPLACE(OrderToLocationNo, '-BLI', ''),
                                                        '-JLR', ''),
                                                '-HYU', ''),
                                        '-HUY', '')
        END
    WHERE [id] = @order_id;


    UPDATE dbo.OrderLines
    SET OrderToLocationNo = CASE
                                WHEN OrderToLocationNo LIKE '%-HYU-HYU'
                                    THEN REPLACE(OrderToLocationNo, '-HYU-HYU', '-HYU')
                                WHEN OrderToLocationNo LIKE '%-BLI-BLI'
                                    THEN REPLACE(OrderToLocationNo, '-BLI-BLI', '-BLI')
                                WHEN OrderToLocationNo LIKE '%-JLR-JLR'
                                    THEN REPLACE(OrderToLocationNo, '-JLR-JLR', '-JLR')
                                ELSE REPLACE(
                                        REPLACE(
                                                REPLACE(
                                                        REPLACE(OrderToLocationNo, '-BLI', ''),
                                                        '-JLR', ''),
                                                '-HYU', ''),
                                        '-HUY', '')
        END
    WHERE OrderId = @order_id

    DELETE FROM dbo.OrderLines WHERE Qty = 0 AND OrderId = @order_id;

    UPDATE dbo.Orders
    SET status = CASE
                     WHEN StatusString = 'unconfirmed' THEN 0
                     WHEN StatusString = 'confirmed' THEN 1
                     WHEN StatusString = 'transferred' THEN 2
        END
    WHERE [id] = @order_id


    SELECT 1

END
