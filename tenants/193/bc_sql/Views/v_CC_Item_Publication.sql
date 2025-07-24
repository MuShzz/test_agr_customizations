

CREATE VIEW bc_sql_cus.v_CC_Item_Publication AS

	WITH cte_pub (item_no, publication_no, discontinued_date) AS
		(
		SELECT
			itp.[Item No_] AS item_no, itp.[Publication No_] AS publication_no, itp.[Discontinued Date] AS discontinued_date
		FROM bc_sql_cus.CC_Item_Publication itp
		WHERE itp.Status = 0		-- 0 - Active, 1 - Discontinued
		)
	,
	cte_pub_list(item_no, item_publication_code) AS
		(
		SELECT a.item_no, STUFF((SELECT ', ' + publication_no
		FROM cte_pub b
		WHERE a.item_no = b.item_no
		FOR XML PATH('')),1,2,'') AS item_publication_code
		FROM
		(SELECT DISTINCT item_no
		FROM cte_pub) a
		)
	SELECT * FROM cte_pub_list	


