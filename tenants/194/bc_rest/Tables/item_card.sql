CREATE TABLE [bc_rest_cus].[item_card] (
    [No] NVARCHAR(20) NOT NULL,
    [Description] NVARCHAR(128) NULL,
    [Status] NVARCHAR(128) NULL,
    [Blocked] BIT NULL,
    CONSTRAINT [pk_bc_rest_cus_item_card] PRIMARY KEY (No)
);
