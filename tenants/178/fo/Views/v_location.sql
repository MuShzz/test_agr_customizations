

CREATE VIEW [fo_cus].[v_location]
AS

    SELECT DISTINCT
        CAST(w.WAREHOUSEID AS NVARCHAR(255)) AS [no],
        CAST(w.WAREHOUSENAME AS NVARCHAR(255)) AS [name]
	FROM fo_cus.Warehouses w

