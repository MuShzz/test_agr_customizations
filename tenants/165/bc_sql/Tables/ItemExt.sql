CREATE TABLE [bc_sql_cus].[ItemExt] (
    [No_] NVARCHAR(20) NOT NULL,
    [LSC Retail Product Code$5ecfc871-5d82-43f1-9c54-59685e82318d] NVARCHAR(20) NOT NULL,
    [LSC Item Family Code$5ecfc871-5d82-43f1-9c54-59685e82318d] NVARCHAR(20) NOT NULL,
    [ICE LAG Status Code$63a5512e-ef5c-4cc4-ac67-fc1739ce27d8] NVARCHAR(10) NOT NULL,
    [ICE LAG Order Type$63a5512e-ef5c-4cc4-ac67-fc1739ce27d8] NVARCHAR(10) NOT NULL,
    [Vendor Grouping$63a5512e-ef5c-4cc4-ac67-fc1739ce27d8] NVARCHAR(10) NOT NULL,
    [NOOS$63a5512e-ef5c-4cc4-ac67-fc1739ce27d8] NVARCHAR(10) NOT NULL,
    [Vendor Stock$63a5512e-ef5c-4cc4-ac67-fc1739ce27d8] NVARCHAR(20) NOT NULL,
    [ICE LAG Order Status Code$63a5512e-ef5c-4cc4-ac67-fc1739ce27d8] INT NOT NULL,
    CONSTRAINT [PK_bc_sql_cus_ItemExt] PRIMARY KEY (No_)
);
