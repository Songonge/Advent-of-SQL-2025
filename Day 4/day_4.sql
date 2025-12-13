SELECT *
FROM official_shifts;

SELECT *
FROM last_minute_signups;


-- Using the official_shifts and last_minute_signups tables, create a combined de-duplicated volunteer list.
-- Ensure the list has standardized role labels of Stage Setup, Cocoa Station, Parking Support, 
-- Choir Assistant, Snow Shoveling, Handwarmer Handout.
-- Make sure that the timeslot formats follow John's official shifts format.

WITH cleaned_official AS (
	SELECT 
	volunteer_name,
	CASE 
		WHEN role = 'choir_assistant' THEN 'Choir Assistant'
		WHEN role = 'parking_support' THEN 'Parking Support'
		WHEN role = 'cocoa_station' THEN 'Cocoa Station'
		WHEN role = 'stage_setup' THEN 'Stage Setup'
	END AS assigned_role,
	shift_time as assigned_time
FROM official_shifts
),
cleaned_last_minute AS (
	SELECT 
		volunteer_name,
		CASE 
			WHEN LOWER(assigned_task) IN ('choir', 'choir assistant') THEN 'Choir Assistant'
			WHEN LOWER(assigned_task) IN ('parking', 'parking_support', 'parking-support') THEN 'Parking Support'
			WHEN LOWER(assigned_task) IN ('hot cocoa station', 'cocoa station') THEN 'Cocoa Station'
			WHEN LOWER(assigned_task) IN ('stage_setup', 'stage setup', 'stage-setup') THEN 'Stage Setup'
			WHEN TRIM(assigned_task) = 'stage setup' THEN 'Stage Setup'
			WHEN LOWER(assigned_task) IN ('shovel', 'snow shoveling', 'snow-shoveling') THEN 'Snow Shoveling'
	        WHEN LOWER(assigned_task) IN ('handwarmers', 'handwarmer handout', 'handwarmer-handout') THEN 'Handwarmer Handout'
		END AS assigned_role,
		CASE 
			WHEN time_slot IN ('2 pm', '2 PM') THEN '2:00 PM'
			WHEN time_slot IN ('10 am', '10AM') THEN '10:00 AM'
			WHEN time_slot = 'noon' THEN '12:00 PM'
		END AS assigned_time
	FROM last_minute_signups
)
SELECT 
	DISTINCT
		volunteer_name,
		assigned_role,
		assigned_time
FROM (
	SELECT *
	FROM cleaned_official
	UNION ALL
	SELECT *
	FROM cleaned_last_minute
) combined_tables
;

-- Another way of writing the query without using the subquery. 
WITH cleaned_official AS (
	SELECT 
		volunteer_name,
		CASE 
			WHEN role = 'choir_assistant' THEN 'Choir Assistant'
			WHEN role = 'parking_support' THEN 'Parking Support'
			WHEN role = 'cocoa_station' THEN 'Cocoa Station'
			WHEN role = 'stage_setup' THEN 'Stage Setup'
		END AS assigned_role,
		shift_time as assigned_time
	FROM official_shifts
),
cleaned_last_minute AS (
	SELECT 
		volunteer_name,
		CASE 
			WHEN LOWER(assigned_task) IN ('choir', 'choir assistant') THEN 'Choir Assistant'
			WHEN LOWER(assigned_task) IN ('parking', 'parking_support', 'parking-support') THEN 'Parking Support'
			WHEN LOWER(assigned_task) IN ('hot cocoa station', 'cocoa station') THEN 'Cocoa Station'
			WHEN LOWER(assigned_task) IN ('stage_setup', 'stage setup', 'stage-setup') THEN 'Stage Setup'
			WHEN TRIM(assigned_task) = 'stage setup' THEN 'Stage Setup'
			WHEN LOWER(assigned_task) IN ('shovel', 'snow shoveling', 'snow-shoveling') THEN 'Snow Shoveling'
	        WHEN LOWER(assigned_task) IN ('handwarmers', 'handwarmer handout', 'handwarmer-handout') THEN 'Handwarmer Handout'
		END AS assigned_role,
		CASE 
			WHEN time_slot IN ('2 pm', '2 PM') THEN '2:00 PM'
			WHEN time_slot IN ('10 am', '10AM') THEN '10:00 AM'
			WHEN time_slot = 'noon' THEN '12:00 PM'
		END AS assigned_time
	FROM last_minute_signups
),
combined_tables AS (
	SELECT *
	FROM cleaned_official
	UNION ALL
	SELECT *
	FROM cleaned_last_minute
)
SELECT DISTINCT
	volunteer_name,
	assigned_role,
	assigned_time
FROM combined_tables;





