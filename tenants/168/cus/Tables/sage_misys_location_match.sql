CREATE TABLE [cus].[sage_misys_location_match] (
    [SAGE_LOCATION] NVARCHAR(6) NULL,
    [MISYS_LOCATION] NVARCHAR(6) NULL,
    [undelivered] BIT NULL,
    [bom] BIT NULL,
    [stock_level] BIT NULL
);
