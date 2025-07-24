

-- ===============================================================================
-- Author:      (Jorundur Matthiasson)
-- Create date: 07.08.2020
-- Description: Convert list of strings to table (column string_value)
--              Based on code from Itzik Ben-Gan
-- ===============================================================================
CREATE FUNCTION [cus].[string_list_to_table](@list NVARCHAR(MAX), @separator NCHAR(1), @trim BIT)
  RETURNS TABLE
  RETURN SELECT string_value = CASE WHEN @trim = 1 THEN LTRIM(RTRIM(SUBSTRING(@list, number, CHARINDEX(@separator, @list + @separator, number) - number)))
                                    ELSE SUBSTRING(@list, number, CHARINDEX(@separator, @list + @separator, number) - number) END
           FROM cus.numbers(LEN(@list) + 1)
          WHERE SUBSTRING(@separator + @list, number, 1) = @separator

