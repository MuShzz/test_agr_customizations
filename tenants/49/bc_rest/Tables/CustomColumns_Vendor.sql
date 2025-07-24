CREATE TABLE [bc_rest_cus].[CustomColumns_Vendor] (
    [no] NVARCHAR(20) NOT NULL,
    [minOrderPallets] DECIMAL(18,4) NULL,
    [minOrderAmount] DECIMAL(18,4) NULL,
    [minOrderCases] DECIMAL(18,4) NULL,
    [minOrderCubage] DECIMAL(18,4) NULL,
    CONSTRAINT [PK_CustomColumns_vendor] PRIMARY KEY (no)
);
