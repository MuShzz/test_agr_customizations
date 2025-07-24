CREATE VIEW [cus].[v_UndeliveredPO]
AS

SELECT  CAST(CAST(PurchaseOrder AS DECIMAL(18,0)) AS VARCHAR(50)) AS PurchaseOrder,
		CAST(CAST(PurchaseOrderItem AS DECIMAL(18,0)) AS VARCHAR(50)) AS PurchaseOrderItem, 
       SequentialNumber,
       ConfirmationCategory,
	   CAST(DeliveryDate AS DATE) AS [DeliveryDate],
       --[cus].[UnixTimeConvert]([DeliveryDate]) AS [DeliveryDate],
       Quantity,
       CreatedOn,
       InboundDelivery 
	   FROM cus.UndeliveredPO
	   where PurchaseOrder IS NOT NULL
       

