CREATE TABLE [cus].[Supplier] (
    [SupplierCode] NVARCHAR(30) NOT NULL,
    [SupplierName] NVARCHAR(100) NULL,
    [IsActive] BIT NULL,
    [WarehouseCode] NVARCHAR(30) NULL,
    [CurrencyCode] NVARCHAR(30) NULL,
    [LeadTimeCalendarDays_C] DECIMAL(18,1) NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_Supplier] PRIMARY KEY (SupplierCode)
);
