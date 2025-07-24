

/****** Object:  View [cus_adi].[v_bom_component]    Script Date: 10/23/2024 4:33:28 PM ******/

-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Data mapping from CUS
--
--  12.03.2023.HMH   Created
-- ====================================================================================================

CREATE VIEW [cus].[v_BOM_COMPONENT] AS
	
	SELECT
        CAST(vb_vad_id AS NVARCHAR(255)) AS [item_no],
        CAST(vbc_vad_id AS NVARCHAR(255)) AS [component_item_no],
        SUM(CAST(vbc_quantity AS DECIMAL(18,4))) AS [quantity]
   FROM cus.BOM_Component
   GROUP BY CAST(vb_vad_id AS NVARCHAR(255)), CAST(vbc_vad_id AS NVARCHAR(255))


