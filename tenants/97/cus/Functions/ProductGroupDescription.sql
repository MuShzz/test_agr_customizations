

CREATE FUNCTION [cus].[ProductGroupDescription](@CategoryCode NVARCHAR(20), @GroupCode NVARCHAR(10), @GroupDescription NVARCHAR(50),@Company NVARCHAR(5))
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @ReturnGroupDescription NVARCHAR(255)

    IF EXISTS(SELECT 1 FROM cus.ItemCategory WHERE Code = @GroupCode AND Company = @Company)
        SET @ReturnGroupDescription = (SELECT TOP 1 [Description] FROM cus.ItemCategory WHERE Code = @CategoryCode AND Company = @Company) + ' > ' + @GroupDescription
    ELSE IF (SELECT COUNT(1) FROM cus.ProductGroup WHERE Code = @GroupCode AND Company = @Company) > 1
        SET @ReturnGroupDescription = ISNULL((SELECT TOP 1  [Description] FROM cus.ItemCategory WHERE Code = @CategoryCode AND Company = @Company),'') + ' > ' + @GroupDescription
    ELSE
        SET @ReturnGroupDescription = @GroupDescription

    RETURN @ReturnGroupDescription
END




