
-- ===============================================================================
-- Author: Arndís YH
-- Create date: 06.05.2024
-- Description:	View that is used to map into SalesHeader and SalesLine
--				This view is used in views [nav_cus].[SalesHeader] and [nav_cus].[SalesLine]
-- ===============================================================================

CREATE VIEW [nav_cus].[v_SalesOrderLineExtraDetails]
AS

with cte as (

	select 
	item_no, 
	location_no, 
	demand_date, 
	sum(case when Magn > 0 then Magn else 0 end ) as demand,
	[þjónustupöntun],
	Status --
	from (
		select 
		item_no, 
		location_no, 
		demand_date, 
		MagnTilAfhendingar - Magn as Magn,
		[þjónustupöntun],
		Status 
		from (
			select  
			afs.[Vörunúmer] as item_no, 
			'G0001' as location_no, 
			sh.[Starting Date] as demand_date, 
			afs.[línunúmer], 
			afs.Tilbodsmagn, 
			afs.MagnTilAfhendingar, 
			isnull(af.magn, 0) as Magn,
			afs.[þjónustupöntun],
			sh.Status 
			from (
				select [Vörunúmer], [Þjónustupöntun], [Línunúmer], SUM([Tilboðsmagn]) as Tilbodsmagn, SUM([Magn til afhendingar]) as MagnTilAfhendingar 
				from [nav_cus].AfhendingaStaða
				group by [Vörunúmer], [Þjónustupöntun], [Línunúmer]
			) afs
			left outer join (
				select [Vörunúmer], [Þjónustupöntun], [Línunúmer], SUM(Magn) as Magn 
				from [nav_cus].Afhendingar 
				where Tegund=0 
				group by [Vörunúmer], [Þjónustupöntun], [Línunúmer]
			) af on af.[Vörunúmer] = afs.[Vörunúmer] and af.[Þjónustupöntun] = afs.[Þjónustupöntun] and af.[Línunúmer] = afs.[Línunúmer]
			inner join [nav_cus].ServiceHeader sh on sh.No_ = afs.[ÞJónustupöntun]
		) u
	) v
	group by 
	item_no, 
	location_no, 
	demand_date, 
	[þjónustupöntun],
	Status
	)
	select 
		cast(item_no as nvarchar)  as item_no, 
		cast(location_no as nvarchar) as location_no,
		cast(c.demand_date as date) as reserved_date,
		CAST(demand AS DECIMAL(18,4)) AS units,
		CAST('' AS NVARCHAR(255)) AS description,
		[þjónustupöntun] as sales_no
		--Status
	from cte c 
	where demand<>0
	and (isnull(item_no,'') <>'')
	and Status <> 4 






