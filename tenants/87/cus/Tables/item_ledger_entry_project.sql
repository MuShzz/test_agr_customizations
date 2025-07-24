CREATE TABLE [cus].[item_ledger_entry_project] (
    [Entry_No] INT NOT NULL,
    [Project_Yes_No] BIT NOT NULL,
    [COMPANY] NVARCHAR(100) NULL,
    CONSTRAINT [pk_item_ledger_entry_project] PRIMARY KEY (Entry_No)
);
