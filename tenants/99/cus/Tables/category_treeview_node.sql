CREATE TABLE [cus].[category_treeview_node] (
    [ctn_id] INT NOT NULL,
    [ctn_parent_id] INT NOT NULL,
    [ctn_description] NVARCHAR(150) NOT NULL,
    CONSTRAINT [pk_cus_category_treeview_node] PRIMARY KEY (ctn_id)
);
