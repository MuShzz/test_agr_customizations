



   -- ===============================================================================
-- Author:      Ágúst Örn Grétarsson
-- Description: Customized to close items 
--
-- 06.05.2014.RJ  Created
-- ===============================================================================

CREATE VIEW [nav_cus].[v_Item_closed]
AS

		select i.No_,
		case 
			when i.No_ LIKE 'GSM-%' AND (i.[Vendor No_] ='' OR v.Blocked <> 0) then CAST(1 as BIT) 
			when i2.Birgðarflokkur =4  OR i2.[Not for purchase]=1 OR i2.[Item not active]=1 then CAST(1 as BIT) 
			else  CAST(i.[Blocked] AS BIT) end AS Closed
		from nav.Item i
		INNER JOIN [nav_cus].[Custom_Item] i2 ON i2.No_ = i.No_
		LEFT JOIN dbo.Vendor v ON v.No_ = i.[Vendor No_]


