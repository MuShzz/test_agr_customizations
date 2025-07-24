CREATE TABLE [bc_sql_cus].[circular_bom] (
    [item_no] NVARCHAR(20) NOT NULL,
    [src] VARCHAR(20) NOT NULL,
    CONSTRAINT [PK__circular__FFDFD761EFDC4A79] PRIMARY KEY (item_no,src)
);
