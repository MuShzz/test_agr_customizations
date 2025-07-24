CREATE TABLE [cus].[item_ledger_entry_custom] (
    [EntryNo] INT NOT NULL,
    [ItemNo] VARCHAR(20) NOT NULL,
    [Project] BIT NOT NULL,
    CONSTRAINT [pk_item_ledger_entry_custom] PRIMARY KEY (EntryNo)
);
