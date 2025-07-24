CREATE VIEW [fo_cus].[v_OPEN_SALES_ORDER]
AS

SELECT 
    CAST(sol.SALESORDERNUMBER AS NVARCHAR(128)) AS [sales_order_no],
    CAST(sol.ITEMNUMBER AS NVARCHAR(255)) AS [item_no],
    CAST(ISNULL(sol.SHIPPINGWAREHOUSEID, '') AS NVARCHAR(255)) AS [location_no],
    SUM(CAST(sol.ORDEREDSALESQUANTITY AS DECIMAL(18,4))) AS [quantity], -- Summing quantity
    MAX(CAST(c.CUSTOMERACCOUNT AS NVARCHAR(255))) AS [CUSTOMER_NO], -- Picking one customer account
    DATEFROMPARTS(
        YEAR(sol.CONFIRMEDSHIPDATE),
        MONTH(sol.CONFIRMEDSHIPDATE),
        1
    ) AS [delivery_date] -- 14.07.2025.DRG/JJ: Adding all sales orders to the first date of the month. Request from customer. 
FROM 
    fo_cus.[SalesOrderLines] sol
LEFT JOIN 
    fo.Customers c
    ON sol.DELIVERYADDRESSNAME = c.ADDRESSDESCRIPTION 
    AND sol.DELIVERYADDRESSCITY = c.ADDRESSCITY
WHERE 
    sol.SALESORDERLINESTATUS <> 'Canceled' 
    AND sol.CONFIRMEDSHIPDATE > CAST(GETUTCDATE() AS DATE)
GROUP BY 
    sol.SALESORDERNUMBER, 
    sol.ITEMNUMBER, 
    sol.SHIPPINGWAREHOUSEID, 
    YEAR(sol.CONFIRMEDSHIPDATE),
    MONTH(sol.CONFIRMEDSHIPDATE);

