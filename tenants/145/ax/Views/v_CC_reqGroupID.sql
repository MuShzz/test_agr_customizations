
-- ===============================================================================
-- Author:			Grétar Magnússon
-- Description:		Custom columns requirement group
--
-- 15.04.2025.GM	Created
-- ===============================================================================

CREATE VIEW [ax_cus].[v_CC_reqGroupID]
AS

    SELECT
        CAST(i.NO AS NVARCHAR(255))											AS Item_No,
		CAST(IIF(it.REQGROUPID = '', '', it.REQGROUPID) AS NVARCHAR(50))	AS reqGroupID
	FROM
		ax_cus.INVENTTABLE it
		INNER JOIN adi.ITEM i ON i.NO = it.ITEMID


