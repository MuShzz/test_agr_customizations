

 

-- ===============================================================================
-- Author:     Dana Rut
-- Description: Mapping Assembly Qty
--
--  09.05.2025.DRG
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[v_CC_Assembly]
AS
 
SELECT 
	al.No AS ItemNo, 
	CAST(SUM(al.Quantity) AS INT) AS AssemblyQty
FROM bc_rest_cus.assembly_header ah 
INNER JOIN bc_rest_cus.assembly_line al ON al.DocumentNo = ah.No
WHERE ah.DocumentType = 'Order' 
GROUP BY al.No
HAVING SUM(al.Quantity) > 0



