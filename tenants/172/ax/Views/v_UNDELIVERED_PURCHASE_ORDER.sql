CREATE VIEW [ax_cus].[v_UNDELIVERED_PURCHASE_ORDER] 
AS

       SELECT
            CAST(pt.PURCHID AS VARCHAR(128))                                                                                  AS [PURCHASE_ORDER_NO],
            CAST(it.ITEMID AS NVARCHAR(255))                                                                                  AS [ITEM_NO],
            CAST('Myl' AS NVARCHAR(255))                                                                       AS [LOCATION_NO],
            CAST(pt.DELIVERYDATE AS DATE) AS [DELIVERY_DATE],
            SUM(CAST(it.qty AS DECIMAL(18,4)))                                                                AS [QUANTITY],
            CAST(p.DATAAREAID AS NVARCHAR(4))                                                                               AS [COMPANY]
       FROM  ax_cus.PURCHLINE p
	INNER JOIN  ax_cus.PurchTable pt
				ON p.PURCHID = pt.PurchId
	INNER JOIN ax_cus.InventDim id 
				ON id.INVENTDIMID = p.INVENTDIMID
				AND id.DATAAREAID = p.DATAAREAID 
				AND id.PARTITION=p.PARTITION
	Inner join ax_cus.InventTransOrigin  iTO on iTO.InventTransId = p.InventTransId and iTO.ITEMID = p.ITEMID
	inner join ax_cus.inventtrans it on it.InventTransOrigin = iTO.RECID
	WHERE	(pt.PurchStatus = 0 OR pt.PurchStatus = 1) and id.dataareaid = 'mfk' and id.INVENTLOCATIONID in ('Myl','Toll') and p.RemainPurchPhysical > 0 
				--and st.CUSTACCOUNT is null
				and pt.StatProcID <> 'Gámur' --and i.id in (3140,3128,3127,3086,3084,3083,3079)
				and it.STATUSRECEIPT = 5
				GROUP BY pt.PURCHID,it.ITEMID, id.INVENTLOCATIONID,CAST(pt.DELIVERYDATE AS DATE),pt.PURCHSTATUS, p.DATAAREAID
