


/****** Object:  View [cus_adi].[v_bom_component]    Script Date: 10/23/2024 4:33:28 PM ******/

-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Data mapping from CUS
--
--  12.03.2023.HMH   Created
-- ====================================================================================================

CREATE VIEW [cus].[v_BOM_COMPONENT] AS
	
	SELECT
		CAST(NULL AS NVARCHAR(255)) AS ITEM_NO,
		CAST(NULL AS NVARCHAR(255)) AS COMPONENT_ITEM_NO,
		CAST(NULL AS DECIMAL(18,4)) AS QUANTITY,
		CAST(NULL AS NVARCHAR(255)) AS COMPANY
	WHERE 1=0


