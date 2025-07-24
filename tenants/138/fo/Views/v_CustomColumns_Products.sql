CREATE VIEW [fo_cus].[v_CustomColumns_Products] AS

SELECT 
    ITEMNUMBER,
    CASE 
       WHEN BEA219ALIVEITEM = 'Yes' THEN CAST(1 AS BIT)
       WHEN BEA219ALIVEITEM = 'No'  THEN CAST(0 AS BIT)
       ELSE CAST(0 AS BIT)
    END AS ALIVEITEM
FROM [fo_cus].[CustomColumns_Products]
