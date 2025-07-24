CREATE TABLE [cus].[customer_detail] (
    [cd_id] INT NOT NULL,
    [cd_statement_name] NVARCHAR(100) NOT NULL,
    [cd_ow_account] NVARCHAR(30) NULL,
    CONSTRAINT [pk_cus_customer_detail] PRIMARY KEY (cd_id)
);
