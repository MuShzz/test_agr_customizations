CREATE TABLE [cus].[fetch_state] (
    [endpoint_id] INT NOT NULL,
    [last_skip] INT NULL,
    [last_nextLink] NVARCHAR(MAX) NULL,
    [last_processed_time] DATETIME NULL,
    [status] NVARCHAR(20) NULL,
    [error] NVARCHAR(MAX) NULL
);
