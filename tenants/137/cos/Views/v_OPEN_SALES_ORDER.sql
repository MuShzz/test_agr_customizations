



-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Customer mapping from COS
--
--  12.03.2023.HMH   Created
-- ===============================================================================
CREATE VIEW [cos_cus].[v_OPEN_SALES_ORDER]
AS

  SELECT 
      CAST(sol.SALES_ORDER_NO AS NVARCHAR(128))           AS [SALES_ORDER_NO],
      CAST(sol.PRODUCT_ITEM_NO AS NVARCHAR(255))          AS [ITEM_NO],
      CAST(sol.LOCATION_NO AS NVARCHAR(255))              AS [LOCATION_NO],
      CAST(SUM(sol.QUANTITY) AS DECIMAL(18,4))            AS [QUANTITY],
      CAST(so.CUSTOMER_NO AS NVARCHAR(255))               AS [CUSTOMER_NO],
      CAST(ISNULL(sol.DELIVERY_DATE, GETDATE()) AS DATE)  AS [DELIVERY_DATE]
  FROM 
      [cos_cus].[AGR_SALES_ORDERS_LINE] sol
      INNER JOIN [cos].[AGR_SALES_ORDERS] so ON so.NO=sol.SALES_ORDER_NO
  GROUP BY 
      sol.SALES_ORDER_NO, 
      sol.PRODUCT_ITEM_NO,
      sol.LOCATION_NO,
      sol.EXPIRE_DATE, 
      sol.DELIVERY_DATE, 
      sol.DELIVERY_STATUS, 
      so.CUSTOMER_NO

