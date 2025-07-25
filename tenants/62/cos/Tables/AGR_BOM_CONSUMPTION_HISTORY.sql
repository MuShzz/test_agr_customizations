CREATE TABLE [cos_cus].[AGR_BOM_CONSUMPTION_HISTORY] (
    [ITEM_NO] NVARCHAR(255) NOT NULL,
    [LOCATION_NO] NVARCHAR(255) NOT NULL,
    [DATE] DATE NOT NULL,
    [UNIT_QTY] DECIMAL(18,4) NULL,
    [TRANSACTION_ID] BIGINT NULL,
    CONSTRAINT [pk_cos_cus_agr_bom_consumption_history] PRIMARY KEY (DATE,ITEM_NO,LOCATION_NO)
);
