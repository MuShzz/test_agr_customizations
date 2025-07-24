
CREATE VIEW [bc_sql_cus].[v_routing_time] AS

	SELECT
		it.No_																							AS item_no,
		rl.[Routing No_]																				AS routing_no,
		CAST(SUM (CASE WHEN rl.[Setup Time Unit of Meas_ Code] = 'DAYS' THEN rl.[Setup Time] END
			+ CASE WHEN rl.[Run Time Unit of Meas_ Code] = 'DAYS' THEN rl.[Run Time] END
			+ CASE WHEN rl.[Wait Time Unit of Meas_ Code] = 'DAYS' THEN rl.[Wait Time] END
			+ CASE WHEN rl.[Move Time Unit of Meas_ Code] = 'DAYS' THEN rl.[Move Time] END) AS int)		AS routing_time
	FROM bc_sql_cus.ItemExtraInfo it
		INNER JOIN bc_sql_cus.RoutingLine rl ON it.[Routing No_] = rl.[Routing No_]
	GROUP BY it.No_, rl.[Routing No_]
	HAVING
		SUM (CASE WHEN rl.[Setup Time Unit of Meas_ Code] = 'DAYS' THEN rl.[Setup Time] END
			+ CASE WHEN rl.[Run Time Unit of Meas_ Code] = 'DAYS' THEN rl.[Run Time] END
			+ CASE WHEN rl.[Wait Time Unit of Meas_ Code] = 'DAYS' THEN rl.[Wait Time] END
			+ CASE WHEN rl.[Move Time Unit of Meas_ Code] = 'DAYS' THEN rl.[Move Time] END) > 0


