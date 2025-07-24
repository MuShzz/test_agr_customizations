





CREATE VIEW [cus].[v_bookedInDate]
AS
    SELECT 
        pl.ItemCode, 
        ls.location_no,
        MIN(p.DocDueDate) AS mindate,
        CAST(MIN(p.U_U_BookDate) AS NVARCHAR(255)) AS U_U_BookDate
    FROM 
        cus.POR1 pl
    INNER JOIN 
        cus.OPOR p ON p.DocEntry = pl.DocEntry
    INNER JOIN 
        [cus].[v_location_setup] ls ON ls.source_location_no = pl.WhsCode
    WHERE 
        pl.LineStatus = 'O'  
        AND pl.ItemCode IS NOT NULL 
        AND pl.WhsCode IS NOT NULL
    GROUP BY 
        pl.ItemCode, 
        ls.location_no
        

