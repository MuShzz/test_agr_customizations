CREATE TABLE [cus].[Customer] (
    [CustomerCode] NVARCHAR(30) NOT NULL,
    [CustomerName] NVARCHAR(100) NULL,
    [IsActive] BIT NULL,
    [CustomerTier_C] NVARCHAR(50) NULL,
    [DateCreated] DATETIME NULL,
    [DateModified] DATETIME NULL,
    CONSTRAINT [pk_Customer] PRIMARY KEY (CustomerCode)
);
