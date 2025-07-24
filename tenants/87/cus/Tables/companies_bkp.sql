CREATE TABLE [cus].[companies_bkp] (
    [company] CHAR(3) NOT NULL,
    [company_name] NVARCHAR(100) NULL,
    [priority] INT NOT NULL,
    [erp_endpoint] NVARCHAR(1000) NULL,
    [erp_token] NVARCHAR(1000) NULL,
    [erp_user] NVARCHAR(1000) NULL,
    [erp_secret] NVARCHAR(1000) NULL,
    [erp_scope] NVARCHAR(1000) NULL,
    [is_active] BIT NULL,
    [order_endpoint] NVARCHAR(MAX) NULL
);
