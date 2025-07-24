



/****** Object:  View [ogl].[v_sales_order_line]    Script Date: 30/06/2024 14:48:46 ******/


CREATE VIEW [ogl_cus].[v_OPEN_SALES_ORDER]
AS

	  SELECT CAST(o.ordno AS NVARCHAR(128))																			AS [sales_order_no],
		     CAST(ol.stcode AS NVARCHAR(255))																		AS [item_no],
             CAST(o.depot AS NVARCHAR(255))																			AS [location_no],
		     SUM(CAST(ol.quan AS DECIMAL(18,4)))-SUM(CAST(ol.desp AS DECIMAL(18,4)))								AS [quantity],
             CAST(o.cref AS NVARCHAR(255))                                                                          AS [customer_no],
		     CAST(ISNULL(IIF(ol.deldate = '0001-01-01 00:00:00.0000000', NULL, ol.deldate), GETDATE()) AS DATE)		AS [delivery_date]	     
	    FROM [ogl].[SOOrderItems] ol
  INNER JOIN [ogl_cus].[SOOrderHeaders] o ON o.ordno = ol.ordno
       WHERE ol.statusind IN (0,1)
	GROUP BY o.ordno, ol.stcode, o.depot, o.cref, ol.deldate
      HAVING SUM(CAST(ol.quan AS DECIMAL(18,4)))-SUM(CAST(ol.desp AS DECIMAL(18,4))) > 0


