CREATE TABLE [cus].[custom_view_definition] (
    [view_schema] NVARCHAR(128) NOT NULL,
    [view_name] NVARCHAR(128) NOT NULL,
    [view_definition] NVARCHAR(MAX) NOT NULL,
    [custom] BIT NOT NULL
);
