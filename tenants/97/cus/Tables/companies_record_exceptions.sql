CREATE TABLE [cus].[companies_record_exceptions] (
    [entity_name] NVARCHAR(255) NOT NULL,
    [key_value_1] NVARCHAR(255) NOT NULL,
    [key_value_2] NVARCHAR(255) NOT NULL DEFAULT (''),
    [key_value_3] NVARCHAR(255) NOT NULL DEFAULT (''),
    [key_value_4] NVARCHAR(255) NOT NULL DEFAULT (''),
    [company] CHAR(3) NOT NULL,
    CONSTRAINT [FK_companies_record_exceptions_companies] FOREIGN KEY (company) REFERENCES [cus].[companies] (company),
    CONSTRAINT [PK_cus_companies_record_exceptions] PRIMARY KEY (entity_name,key_value_1,key_value_2,key_value_3,key_value_4)
);
