CREATE PROCEDURE [cus].[PopulateProductInfo]
AS
BEGIN
    UPDATE [cus].[product_info]
    SET product_no = [no],
        product_name = [name],
        order_frequency_days = 30,
        qty_per_purchase_unit = 1

END;
