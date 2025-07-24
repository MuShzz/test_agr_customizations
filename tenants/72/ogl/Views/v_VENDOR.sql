




CREATE VIEW [ogl_cus].[v_VENDOR]
AS

    SELECT 
        CAST(s.sref AS NVARCHAR(255)) AS [NO],
        CAST(s.fullname AS NVARCHAR(255)) AS [NAME],
        CAST(ISNULL(dd.leadtime,1) AS SMALLINT) AS LEAD_TIME_DAYS,
        CAST(IIF(sqldeleteflag = 'N', 0, 1) AS BIT) AS CLOSED
    FROM
        [ogl].[PLSuppliers] s
		LEFT JOIN [ogl_cus].[PLDeliveryDetails] dd ON dd.sref = s.sref


