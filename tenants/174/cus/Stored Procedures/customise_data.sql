


-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Custom data
--

-- 2025.06.18.DFS  Created
-- 2025.06.18.DFS AF-22 Update lead time on select vendors on select days

-- ===============================================================================
CREATE PROCEDURE [cus].[customise_data] 
AS
BEGIN
	SET NOCOUNT ON

		--Thursday orders

		IF DATEPART(WEEKDAY, GETDATE()) = 5
		BEGIN

			UPDATE adi.PURCHASE_ORDER_ROUTE
			SET LEAD_TIME_DAYS = 3
			WHERE VENDOR_NO IN ( '3904', '170', '9101' );

			UPDATE adi.VENDOR
			SET LEAD_TIME_DAYS = 3
			WHERE NO IN ( '3904', '170', '9101' );
		END


		--Tuesday orders

		IF DATEPART(WEEKDAY, GETDATE()) = 3
		BEGIN

			UPDATE adi.PURCHASE_ORDER_ROUTE
			SET LEAD_TIME_DAYS = 3
			WHERE VENDOR_NO IN ( '4799', '3799');

			UPDATE adi.VENDOR
			SET LEAD_TIME_DAYS = 3
			WHERE NO IN ( '4799', '3799');

			UPDATE adi.PURCHASE_ORDER_ROUTE
			SET LEAD_TIME_DAYS = 3
			WHERE ITEM_NO IN ( '112168', '122550');


		END;


	SELECT 1
END

