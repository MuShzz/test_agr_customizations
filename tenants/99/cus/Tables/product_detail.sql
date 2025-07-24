CREATE TABLE [cus].[product_detail] (
    [pd_id] INT NOT NULL,
    [pd_product_code] NVARCHAR(50) NOT NULL,
    [pd_abbv_description] NVARCHAR(128) NULL,
    [pd_description] NVARCHAR(150) NULL,
    CONSTRAINT [pk_cus_product_detail] PRIMARY KEY (pd_id)
);
