CREATE TABLE [bc_sql_cus].[CC_Color] (
    [Color Code] NVARCHAR(10) NOT NULL,
    [Color Group Code] NVARCHAR(10) NOT NULL,
    [Description] NVARCHAR(30) NOT NULL,
    CONSTRAINT [pk_bc_sql_cus_CC_Color] PRIMARY KEY (Color Code,Color Group Code)
);
