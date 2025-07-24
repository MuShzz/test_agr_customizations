CREATE TABLE [bc_rest_cus].[customer_extra_info] (
    [No] NVARCHAR(20) NOT NULL,
    [Name] NVARCHAR(100) NULL,
    [Search_Name] NVARCHAR(100) NULL,
    [Blocked] NVARCHAR(10) NULL,
    [trm_Company_Group] NVARCHAR(100) NULL,
    [trm_Chain] NVARCHAR(100) NULL,
    [trm_Customer_Commission_Group] NVARCHAR(100) NULL,
    [Country_Region_Code] NVARCHAR(100) NULL,
    [City] NVARCHAR(100) NULL,
    [Bill_to_Customer_No] NVARCHAR(100) NULL,
    [Customer_Posting_Group] NVARCHAR(100) NULL,
    [County] NVARCHAR(100) NULL,
    CONSTRAINT [pk_bc_Rest_cus_customers_extra_info] PRIMARY KEY (No)
);
