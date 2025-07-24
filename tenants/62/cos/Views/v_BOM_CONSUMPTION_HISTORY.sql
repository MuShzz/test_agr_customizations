

-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Customer mapping from COS
--
--  12.03.2023.HMH   Created
-- ====================================================================================================


CREATE   VIEW [cos_cus].[v_BOM_CONSUMPTION_HISTORY] AS

SELECT
        ROW_NUMBER() OVER ( ORDER BY [DATE],[ITEM_NO],[LOCATION_NO] ASC) AS [TRANSACTION_ID],
        [ITEM_NO],
        [LOCATION_NO],
        [DATE],
        [UNIT_QTY]
    FROM [cos_cus].[AGR_BOM_CONSUMPTION_HISTORY]

