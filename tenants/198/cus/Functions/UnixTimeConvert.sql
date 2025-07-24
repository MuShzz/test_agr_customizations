CREATE FUNCTION [cus].[UnixTimeConvert] (@jsonDate VARCHAR(100))  
RETURNS DATE  AS  
BEGIN 

 DECLARE @unixTimestamp BIGINT

    SET @unixTimestamp = CAST(SUBSTRING(@jsonDate, CHARINDEX('(', @jsonDate) + 1, CHARINDEX(')', @jsonDate) - CHARINDEX('(', @jsonDate) - 1) AS BIGINT)

    DECLARE @epochDate DATETIME = '1970-01-01 00:00:00'
    DECLARE @dateValue DATE

     SET @dateValue = DATEADD(SECOND, @unixTimestamp / 1000, @epochDate)

    RETURN @dateValue

END	
