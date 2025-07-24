CREATE TABLE [cus].[companies_entity_priorities] (
    [entity_name] NVARCHAR(255) NOT NULL,
    [company] CHAR(15) NOT NULL,
    [priority] INT NOT NULL,
    CONSTRAINT [PK_companies_entity_priorities] PRIMARY KEY (company,entity_name)
);
