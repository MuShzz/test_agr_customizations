

-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Customer mapping from erp to raw
--
--  04.07.2023.TO   Created
-- ===============================================================================
CREATE VIEW [nav_cus].[v_InventoryPostingGroup]
AS
	  SELECT cci.[No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS [itemNo] , cci.[Inventory Posting Group] AS columnValue
	  FROM [nav_cus].[CustomColumns_Item] cci
	  LEFT JOIN [dbo].[ItemVariant] iv ON cci.No_ = iv.[Item No_]

