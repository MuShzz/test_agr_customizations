CREATE TABLE [bc_rest_cus].[AGR_Purchase_Header] (
    [No_] NVARCHAR(20) NOT NULL,
    [Document_Type] NVARCHAR(100) NOT NULL,
    [Call_Off_Order] NVARCHAR(100) NOT NULL,
    CONSTRAINT [pk_AGR_Purchase_Header] PRIMARY KEY (No_)
);
