

CREATE VIEW [bc_rest_cus].[v_cc_stockUnitsKg]
AS


    SELECT
        sl.ITEM_NO														AS ITEM_NO,
        CAST(case
				WHEN sl.STOCK_UNITS = 0 then 0 
				ELSE sl.STOCK_UNITS/ium.QtyperUnitofMeasure end AS INT) AS stockUnitsKg
    FROM
       adi.STOCK_LEVEL sl
	   INNER JOIN bc_rest.item_unit_of_measure ium ON ium.ItemNo=sl.ITEM_NO AND ium.QtyperUnitofMeasure<>0
	WHERE ium.Code='KG'



