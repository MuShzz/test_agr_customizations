CREATE VIEW [bc_sql_cus].[v_CC_Commercial_Status_Code]
AS
	WITH Description AS (
	SELECT ROW_NUMBER() OVER( ORDER BY commercial_status_code) AS id, commercial_status_code, name
	FROM
	(
	SELECT 0 AS commercial_status_code, 'Buy Only' AS name
	UNION ALL
	SELECT 1 AS commercial_status_code, 'Buy and Sell' AS name
	UNION ALL
	SELECT 2 AS commercial_status_code, 'Sell Only' AS name
	UNION ALL
	SELECT 3 AS commercial_status_code, 'Don''t Buy or Sell' AS name
	UNION ALL
	SELECT '-99' as item_class, 'Unknown' as name
	) AS x)
	SELECT No_, [ACO Finish$a3d760bd-9288-4964-acc7-2649e678307d] AS [ACO Finish], [ACO Commercial Status$a3d760bd-9288-4964-acc7-2649e678307d] AS  [ACO Commercial Status], d.name AS [Commercial STATUS]
	FROM bc_sql_cus.CC_Commercial_Status_Code LEFT JOIN Description  d ON [ACO Commercial Status$a3d760bd-9288-4964-acc7-2649e678307d] = d.commercial_status_code

