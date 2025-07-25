CREATE TABLE [cos_cus].[AGR_ITEM_Custom_Columns] (
    [NO] NVARCHAR(255) NOT NULL,
    [GP3] DECIMAL(19,5) NULL,
    [RANK] NVARCHAR(12) NULL,
    [DOS] FLOAT(53) NULL,
    [TOTAL_SCORE] NVARCHAR(255) NULL,
    [ADS] DECIMAL(20,6) NULL,
    [POM] DECIMAL(20,6) NULL,
    [QUALITY] DECIMAL(20,6) NULL,
    [REFUND_RATE] DECIMAL(20,6) NULL,
    [BRAND] NVARCHAR(255) NULL,
    [OPEN_ORDERS] INT NOT NULL,
    CONSTRAINT [PK__AGR_ITEM__3214D548CFC3831D] PRIMARY KEY (NO)
);
