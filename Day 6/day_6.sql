-- Retrieving all data from the tables to be used
SELECT *
FROM families;

SELECT *
FROM deliveries_assigned;

-- ============================== THE CHALLENGE ==============================
-- Generate a report that returns the dates and families that have no delivery 
-- assigned after December 14th, -- using the families and deliveries_assigned.

-- Each row in the report should be a date and family name that represents the 
-- dates in which families don't have a delivery assigned yet.

-- Label the columns as unassigned_date and name. Order the results by 
-- unassigned_date and name, respectively, both in ascending order.

WITH future_dates AS (
	SELECT 
		-- To build the missing calendar: Dec 15 → Dec 25
		generate_series(
			'2025-12-15',
			'2025-12-25',
			'1 day'::INTERVAL
		)::DATE AS unassigned_date
)
SELECT 
	f.family_name AS name,
	fd.unassigned_date 
FROM families f
CROSS JOIN future_dates fd -- to create every possible family–date combination
LEFT JOIN deliveries_assigned da -- To match existing deliveries
	ON f.id = da.family_id
	AND da.gift_date = fd.unassigned_date
WHERE da.id IS NULL        -- To keep only the missing deliveries
ORDER BY unassigned_date ASC, name ASC
;

