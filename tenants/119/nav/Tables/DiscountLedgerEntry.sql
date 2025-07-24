CREATE TABLE [nav_cus].[DiscountLedgerEntry] (
    [Entry No_] INT NOT NULL,
    [Offer Type] INT NOT NULL,
    [Offer No_] NVARCHAR(20) NOT NULL,
    [Posting Date] DATETIME2 NOT NULL,
    [Document No_] NVARCHAR(20) NOT NULL,
    [Item Ledger Entry No_] INT NOT NULL,
    [Quantity] DECIMAL(38,20) NOT NULL,
    [Quantity Factor] DECIMAL(38,20) NOT NULL,
    [Sales Amount] DECIMAL(38,20) NOT NULL,
    [Sales Amount Factor] DECIMAL(38,20) NOT NULL,
    [Discount Amount] DECIMAL(38,20) NOT NULL,
    [Discount Factor] DECIMAL(38,20) NOT NULL,
    [Cost Amount] DECIMAL(38,20) NOT NULL,
    [Entry Type] INT NOT NULL,
    [Item No_] NVARCHAR(20) NOT NULL,
    CONSTRAINT [pk_DiscountLedgerEntry] PRIMARY KEY (Entry No_,Offer No_,Offer Type)
);
