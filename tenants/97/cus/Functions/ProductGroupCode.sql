

CREATE FUNCTION [cus].[ProductGroupCode](@CategoryCode NVARCHAR(20), @GroupCode NVARCHAR(10),@Company NVARCHAR(5))
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @ReturnGroupCode NVARCHAR(255)

    IF EXISTS(SELECT 1 FROM cus.ItemCategory WHERE Code = @GroupCode AND Company = @Company)
        SET @ReturnGroupCode = @CategoryCode + ' > ' + @GroupCode
    ELSE IF (SELECT COUNT(1) FROM cus.ProductGroup WHERE Code = @GroupCode AND Company = @Company) > 1
        SET @ReturnGroupCode = @CategoryCode + ' > ' + @GroupCode
    ELSE
        SET @ReturnGroupCode = @GroupCode

    RETURN @ReturnGroupCode
END	

