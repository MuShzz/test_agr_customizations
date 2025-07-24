


-- ===============================================================================
-- Author:      (Jorundur Matthiasson)
-- Create date: 07.08.2020
-- Description: Very fast inline table function returning table of numbers (column number)
--              Code from Itzik Ben-Gan
-- ===============================================================================
CREATE FUNCTION [cus].[numbers](@number INT)
  RETURNS TABLE
  RETURN WITH l0   AS(SELECT 1 AS c UNION ALL SELECT 1),
              l1   AS(SELECT 1 AS c FROM l0 AS a, l0 AS b),
              l2   AS(SELECT 1 AS c FROM l1 AS a, l1 AS b),
              l3   AS(SELECT 1 AS c FROM l2 AS a, l2 AS b),
              l4   AS(SELECT 1 AS c FROM l3 AS a, l3 AS b),
              l5   AS(SELECT 1 AS c FROM l4 AS a, l4 AS b),
              nums AS(SELECT ROW_NUMBER() OVER(ORDER BY c) AS number FROM l5)
         SELECT number FROM nums WHERE number <= @number;

