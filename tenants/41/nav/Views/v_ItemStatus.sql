

-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Customer mapping from erp to raw
--
--  04.07.2023.TO   Created
-- ===============================================================================
CREATE VIEW [nav_cus].[v_ItemStatus]
AS
	  SELECT cci.[No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS [itemNo] ,        
	  CASE cci.[Item Status]
           WHEN 3 THEN
               'Permanent'
           WHEN 4 THEN
               'Temporary'
           WHEN 5 THEN
               'Discontinued'
           WHEN 6 THEN
               'Dormant'
		   ELSE ''
       END AS columnValue
	  FROM [nav_cus].[CustomColumns_Item] cci
	  LEFT JOIN [dbo].[ItemVariant] iv ON cci.No_ = iv.[Item No_]

