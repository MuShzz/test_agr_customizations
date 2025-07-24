

-- ===============================================================================
-- Author:      Ágúst Örn Grétarsson
-- Description:
--
-- 11.10.2019.AOG   Recreated to fit the latest Navision BC date formulas
-- 24.11.2021.TO    If @calc is NULL then return NULL
-- 20.02.2023.AOG   DEV-6038 - Improve formula
-- 14.03.2023.AOG   DEV-6207 - Add weeks
-- 13.03.2024.AOG   DEV-8278 - Fix Dx edge case where x exceeds number of days in month
-- ===============================================================================
CREATE FUNCTION [cus].[LeadTimeConvert] (@calc VARCHAR(32), @date DATE)  
RETURNS SMALLINT AS  
BEGIN 
    DECLARE @date_out DATE = @date

    -- we split on + so if the formula looks something like this: 1W-2D then we need to change the - to a +-
    IF CHARINDEX('-',@calc,2) > 0
        SET @calc = REPLACE(@calc,'-','+-')

    DECLARE @formula TABLE(id INT IDENTITY, part NVARCHAR(10))

    INSERT INTO @formula (part)
        SELECT value FROM STRING_SPLIT(@calc,'+') WHERE value != ''

    DECLARE @cnt INT = @@ROWCOUNT
    DECLARE @i INT = 1
    DECLARE @part NVARCHAR(10)
    DECLARE @negative BIT
    DECLARE @num INT
    -- according to BC the week starts on a monday (1)
    DECLARE @week_start_day INT = 1
    WHILE @i <= @cnt
    BEGIN
        SELECT @part = part FROM @formula WHERE id = @i
        IF SUBSTRING(@part,1,1) = '-'
            BEGIN
                SET @negative = 1 
                -- cut of the - sign
                SET @part = SUBSTRING(@part,2,99)
            END
                ELSE SET @negative = 0
        
        -- next weekday
        IF @part LIKE 'WD[0-9]%'
        BEGIN
            SET @num = SUBSTRING(@part,3,1)
            IF ((DATEPART(WEEKDAY, @date_out) + @@DATEFIRST + 6) % 7) = @num
                SET @date_out = DATEADD(WEEK, 1, @date_out)
            ELSE
                SET @date_out = DATEADD(DAY, (7 - ((DATEPART(WEEKDAY, @date_out) + @@DATEFIRST + 6 - @week_start_day) % 7 + 1) + @num) % 7 , @date_out)
        END 
        -- next day
        IF @part LIKE 'D[0-9]%'
        BEGIN
            SET @num = SUBSTRING(@part,2,99)
            IF @negative = 1
                BEGIN
                    IF @num >= DATEPART(DAY,@date_out)
                        SET @date_out = DATEFROMPARTS(YEAR(DATEADD(MONTH,-1,@date_out)),MONTH(DATEADD(MONTH,-1,@date_out)),LEAST(@num,DAY(EOMONTH(DATEADD(MONTH,-1,@date_out)))))
                    ELSE
                        SET @date_out = DATEFROMPARTS(YEAR(@date_out),MONTH(@date_out),LEAST(@num,DAY(EOMONTH(@date_out))))
                END
            ELSE
                BEGIN
                    IF @num > DATEPART(DAY,@date_out)
                        SET @date_out = DATEFROMPARTS(YEAR(@date_out),MONTH(@date_out),LEAST(@num,DAY(EOMONTH(@date_out))))
                    ELSE
                        SET @date_out = DATEFROMPARTS(YEAR(DATEADD(MONTH,1,@date_out)),MONTH(DATEADD(MONTH,1,@date_out)),LEAST(@num,DAY(EOMONTH(DATEADD(MONTH,1,@date_out)))))
                END
        END 
        -- current year
        ELSE IF @part LIKE 'CY%'
        BEGIN
            IF @negative = 1
                SET @date_out = DATEFROMPARTS(YEAR(@date_out),1,1)
            ELSE
                SET @date_out = DATEFROMPARTS(YEAR(@date_out),12,31)
        END
        -- current quarter
        ELSE IF @part LIKE 'CQ%'
        BEGIN
            IF @negative = 1
                SET @date_out = DATEADD(DAY,-1,DATEADD(QUARTER,DATEDIFF(QUARTER,0,@date_out)+1,0))
            ELSE
                SET @date_out = DATEFROMPARTS(YEAR(@date_out),DATEPART(QUARTER,@date_out)*3-2,1)
        END
        -- current month
        ELSE IF @part LIKE 'CM%'
        BEGIN
            IF @negative = 1
                SET @date_out = DATEFROMPARTS(YEAR(@date_out),MONTH(@date_out),1)
            ELSE
                SET @date_out = EOMONTH(@date_out)
        END
        -- current week
        ELSE IF @part LIKE 'CW%'
        BEGIN
            IF @negative = 1
                SET @date_out = DATEADD(DAY,-((DATEPART(WEEKDAY, @date_out) + @@DATEFIRST + 6 - @week_start_day) % 7 + 1)+1,@date_out)
            ELSE
                SET @date_out = DATEADD(DAY,7-((DATEPART(WEEKDAY, @date_out) + @@DATEFIRST + 6 - @week_start_day) % 7 + 1),@date_out)
        END
        -- year
        ELSE IF @part LIKE '%[0-9]Y'
        BEGIN
            SET @num = CAST(SUBSTRING(@part,1,LEN(@part)-1) AS INT) * IIF(@negative = 1, -1, 1)
            SET @date_out = DATEADD(YEAR,@num,@date_out)
        END
        -- quarter
        ELSE IF @part LIKE '%[0-9]Q'
        BEGIN
            SET @num = CAST(SUBSTRING(@part,1,LEN(@part)-1) AS INT) * IIF(@negative = 1, -1, 1)
            SET @date_out = DATEADD(QUARTER,@num,@date_out)
        END
        -- month
        ELSE IF @part LIKE '%[0-9]M'
        BEGIN
            SET @num = CAST(SUBSTRING(@part,1,LEN(@part)-1) AS INT) * IIF(@negative = 1, -1, 1)
            SET @date_out = DATEADD(MONTH,@num,@date_out)
        END
        -- week
        ELSE IF @part LIKE '%[0-9]W'
        BEGIN
            SET @num = CAST(SUBSTRING(@part,1,LEN(@part)-1) AS INT) * IIF(@negative = 1, -1, 1)
            SET @date_out = DATEADD(WEEK,@num,@date_out)
        END
        -- day
        ELSE IF @part LIKE '%[0-9]D'
        BEGIN
            SET @num = CAST(SUBSTRING(@part,1,LEN(@part)-1) AS INT) * IIF(@negative = 1, -1, 1)
            SET @date_out = DATEADD(DAY,@num,@date_out)
        END
        SET @i = @i + 1
    END

    RETURN IIF(@calc IS NULL OR @calc = '', NULL,IIF(DATEDIFF(DAY,@date,@date_out)<0,0,DATEDIFF(DAY,@date,@date_out)))
END

