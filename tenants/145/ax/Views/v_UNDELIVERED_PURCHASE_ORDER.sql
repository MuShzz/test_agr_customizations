CREATE VIEW [ax_cus].[v_UNDELIVERED_PURCHASE_ORDER] 
AS

       SELECT
            CAST(p.PURCHID AS VARCHAR(128))                                                                                 AS [PURCHASE_ORDER_NO],
            CAST(iv.NO AS NVARCHAR(255))																					AS [ITEM_NO],
            CAST(id.INVENTLOCATIONID AS NVARCHAR(255))                                                                      AS [LOCATION_NO],
            CAST(CASE WHEN p.CONFIRMEDDLV = '1900-01-01' THEN p.DELIVERYDATE ELSE p.CONFIRMEDDLV END AS DATE)				AS [DELIVERY_DATE], --17.07.2025.DFS added to SaaS from OnPrem
            SUM(CAST(p.QTYORDERED AS DECIMAL(18,4)))                                                                        AS [QUANTITY],
            CAST(p.DATAAREAID AS NVARCHAR(4))                                                                               AS [COMPANY]
       FROM [ax_cus].PURCHLINE p
		INNER JOIN [ax_cus].INVENTDIM id ON id.INVENTDIMID = p.INVENTDIMID AND id.DATAAREAID = p.DATAAREAID AND id.PARTITION = p.PARTITION
		INNER JOIN ax_cus.Item_v iv ON iv.No_TO_JOIN_IL = p.ITEMID
        INNER JOIN ax_cus.PURCHTABLE pt ON pt.PURCHID = p.PURCHID
	   WHERE 1 = 1
       		AND p.PURCHSTATUS = 1 -- Use the purch line info instead of the header info - 23.03.2022.ÞG --17.07.2025.DFS added to SaaS from OnPrem
		    AND pt.DOCUMENTSTATE IN (35,40)		--Staða samþykkis = Staðfest   -> Draft: 0 (drög) ,InReview: 10  (í endurskoðun), Rejected: 20 (hafnað) --,Approved: 30 (samþykkt), InExternalReview: 35 (í ytri yfirferð), Finalized: 50 (lokið) --17.07.2025.DFS added to SaaS from OnPrem	
		--CAST(p.REMAINPURCHPHYSICAL AS DECIMAL(18,4)) > 0
            --AND iv.NO = '1188866'
	   GROUP BY p.PURCHID, iv.NO, id.INVENTLOCATIONID, CASE WHEN p.CONFIRMEDDLV = '1900-01-01' THEN p.DELIVERYDATE ELSE p.CONFIRMEDDLV END, CAST(p.DATAAREAID AS NVARCHAR(4))

