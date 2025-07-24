


-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Vendor mapping from erp to raw forma, Sage 200
--
--  04.07.2023.TO   Created
-- ===============================================================================
CREATE VIEW [bc_sql_cus].[v_CCUndeliveredAssembly]
AS

    SELECT
        [Item No_],
        SUM([Remaining Quantity]) AS [Remaining Quantity]
    FROM bc_sql_cus.CCUndeliveredAssembly
	GROUP BY [Item No_]

