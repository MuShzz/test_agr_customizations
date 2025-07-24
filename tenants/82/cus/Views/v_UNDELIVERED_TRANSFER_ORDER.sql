

-- ===============================================================================
-- Author:      José Sucena
-- Description: Undelivered Transfer Order Data mapping from CUS
--
--  23.09.2024.HMH   Created
-- ===============================================================================

CREATE VIEW [cus].[v_UNDELIVERED_TRANSFER_ORDER] 
AS

       SELECT
            CAST(itl.TRANSFERID AS VARCHAR(128)) AS [TRANSFER_ORDER_NO],
            CAST(itl.ITEMID AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(itt.INVENTLOCATIONIDTO AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(itl.RECEIVEDATE AS DATE) AS [DELIVERY_DATE],
            SUM(CAST(itl.QTYREMAINRECEIVE AS DECIMAL(18,4))) AS [QUANTITY],
            CAST(itt.INVENTLOCATIONIDFROM AS NVARCHAR(255)) AS [ORDER_FROM_LOCATION_NO]
       FROM [cus].[INVENTTRANSFERLINE] itl
		INNER JOIN [cus].[INVENTTRANSFERTABLE] itt ON itl.TRANSFERID = itt.TRANSFERID AND itl.DATAAREAID = itt.DATAAREAID
	   WHERE	
		itt.TRANSFERSTATUS < 2  
		--Rosendahl specific AND itl.DATAAREAID='rdg'
		--Rosendahl specific AND itt.INVENTLOCATIONIDTO ='ROSNAKSKOV' 
	   GROUP BY itl.TRANSFERID, itl.ITEMID, itt.INVENTLOCATIONIDTO, itt.INVENTLOCATIONIDFROM, itl.RECEIVEDATE


