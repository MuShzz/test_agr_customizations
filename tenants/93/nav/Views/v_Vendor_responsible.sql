


   -- ===============================================================================
-- Author:      Ágúst Örn Grétarsson
-- Description: Customized responsible
--
-- 06.05.2014.RJ  Created
-- ===============================================================================

CREATE VIEW [nav_cus].[v_Vendor_responsible]
AS

		select 
		v.No_ as vendor_no,
		ISNULL(v2.[Product Manager],'') as Responsible
		from [nav].[Vendor] v 
		LEFT JOIN [nav_cus].[Custom_Vendor] v2 ON v2.No_ = v.No_ 



