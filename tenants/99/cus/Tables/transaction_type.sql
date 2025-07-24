CREATE TABLE [cus].[transaction_type] (
    [tt_id] INT NOT NULL,
    [tt_transaction_type] NVARCHAR(5) NULL,
    CONSTRAINT [pk_cus_transaction_type] PRIMARY KEY (tt_id)
);
