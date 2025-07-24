CREATE TABLE [cus].[Stock_History] (
    [transaction_id] NVARCHAR(25) NULL,
    [item_no] NVARCHAR(25) NULL,
    [location_no] NVARCHAR(10) NULL,
    [date] DATETIME NULL,
    [stock_move] DECIMAL(18,4) NULL
);
