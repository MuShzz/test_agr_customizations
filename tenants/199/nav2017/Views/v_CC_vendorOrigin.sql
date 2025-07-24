
CREATE VIEW [nav2017_cus].[v_CC_vendorOrigin] AS

    SELECT
        i.NO AS itemNo
        ,i.PRIMARY_VENDOR_NO AS vendorNo 
        ,vei.[Vendor Posting Group]
    FROM
        adi.ITEM i
        JOIN nav2017_cus.VendorExtraInfo vei ON vei.[No_] = i.PRIMARY_VENDOR_NO

