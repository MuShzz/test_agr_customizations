



CREATE VIEW [ogl_cus].[v_ItemSupplier]
AS

		SELECT aei.[itemNo],
			   aei.[locationNo],
			   pls.minordval,
			   pls.carriage
	FROM dbo.AGREssentials_items aei
	INNER JOIN ogl.STStockDetails sd ON aei.itemNo = sd.stcode
	INNER JOIN ogl_cus.PLSuppliersCC pls ON pls.sref = IIF(sd.sref1 = '',IIF(sd.sref2 = '', sd.sref3, sd.sref2), sd.sref1)


