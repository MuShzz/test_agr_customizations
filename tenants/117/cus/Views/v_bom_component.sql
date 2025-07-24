




/****** Object:  View [cus_adi].[v_bom_component]    Script Date: 10/23/2024 4:33:28 PM ******/

-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Data mapping from CUS
--
--  12.03.2023.HMH   Created
-- ====================================================================================================

CREATE VIEW [cus].[v_bom_component] AS
	
	SELECT CAST(ec.[PartNum] AS NVARCHAR(255))			AS [ITEM_NO],
			   CAST(ec.[MtlPartNum] AS NVARCHAR(255))		AS [COMPONENT_ITEM_NO],
			   SUM(CAST(ec.[QtyPer] AS DECIMAL(18,4)))		AS [QUANTITY]
		  FROM [cus].[PartMtl] ec
	INNER JOIN [cus].[Part] pt	ON ec.[PartNum] = pt.[PartNum]
	INNER JOIN [cus].[Part] ptc ON ec.[MtlPartNum] = ptc.[PartNum]
		 WHERE pt.InActive = 0 
		   AND ptc.InActive = 0
		   AND ec.[AltMethod] = ''

	  GROUP BY ec.[PartNum], ec.[MtlPartNum]
	  HAVING SUM(CAST(ec.[QtyPer] AS DECIMAL(18,4))) > 0


