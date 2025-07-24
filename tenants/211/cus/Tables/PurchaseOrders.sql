CREATE TABLE [cus].[PurchaseOrders] (
    [id] NVARCHAR(255) NULL,
    [supplierId] NVARCHAR(255) NULL,
    [storeId] NVARCHAR(255) NULL,
    [billingCurrency] NVARCHAR(255) NULL,
    [purchaseOrderForm_lineItems_lineItemId] NVARCHAR(255) NULL,
    [purchaseOrderForm_lineItems_code] NVARCHAR(255) NULL,
    [purchaseOrderForm_lineItems_displayName] NVARCHAR(255) NULL,
    [purchaseOrderForm_lineItems_quantity] DECIMAL(18,4) NULL,
    [purchaseOrderForm_lineItems_deliveryQuantity] DECIMAL(18,4) NULL,
    [purchaseOrderForm_lineItems_canceledQuantity] DECIMAL(18,4) NULL,
    [purchaseOrderForm_lineItems_currency] NVARCHAR(255) NULL,
    [purchaseOrderForm_lineItems_supplierSkuId] NVARCHAR(255) NULL,
    [purchaseOrderForm_lineItems_supplierName] NVARCHAR(255) NULL,
    [purchaseOrderForm_lineItems_supplierPackagingQuantity] DECIMAL(18,4) NULL,
    [referenceNumber] NVARCHAR(255) NULL,
    [status] NVARCHAR(255) NULL,
    [isDelivery] NVARCHAR(255) NULL
);
