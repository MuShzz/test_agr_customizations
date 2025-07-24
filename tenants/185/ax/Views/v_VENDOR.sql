
CREATE VIEW [ax_cus].[v_VENDOR] 
AS

    SELECT
        CAST(v.ACCOUNTNUM AS NVARCHAR(255)) AS [NO],
        CAST(dpt.NAME AS NVARCHAR(255)) AS [NAME],
        CAST(v.AGRDELIVERYTIME AS SMALLINT) AS LEAD_TIME_DAYS,
        CAST(0 AS BIT) AS CLOSED,
        CAST(v.DATAAREAID AS NVARCHAR(4))    AS [COMPANY]

    FROM         
        ax.VENDTABLE v
        LEFT OUTER JOIN  ax_cus.INVENTBUYERGROUP ib    ON v.ITEMBUYERGROUPID = ib.GROUP_ AND v.DATAAREAID = ib.DATAAREAID
        INNER JOIN ax_cus.DataAreas da                     ON da.DataAreaId = v.DATAAREAID AND da.Partition = v.PARTITION
        INNER JOIN ax.DIRPARTYTABLE dpt            ON v.PARTY = dpt.RECID AND v.Partition = dpt.PARTITION  


