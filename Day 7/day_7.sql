SELECT *
FROM passengers;

SELECT *
FROM cocoa_cars;


-- ============================ THE CHALLENGE =============================
-- Get the stewards a list of all the passengers and the cocoa car(s) they 
-- can be served from that has at least one of their favorite mixins.

-- Remember only the top three most-stocked cocoa cars remained operational, 
-- so the passengers must be served from one of those cars.

WITH top_cocoa_cars AS (
    SELECT
        car_id,
        available_mixins
    FROM cocoa_cars
    ORDER BY total_stock DESC
    LIMIT 3 -- Keep only the top 3.
)
SELECT
    p.passenger_name,
    c.car_id AS cocoa_car_id
FROM passengers p
JOIN top_cocoa_cars c
	-- Check if the two arrays share at least one common element.
	-- That is the purpose of the && operator.
    ON p.favorite_mixins && c.available_mixins
ORDER BY p.passenger_name, cocoa_car_id;


-- Another way of writing the query using the unnest function.
WITH top_cocoa_cars AS (
    SELECT
        car_id,
        available_mixins
    FROM cocoa_cars
    ORDER BY total_stock DESC
    LIMIT 3
),
passenger_mixins AS (
    SELECT
        p.passenger_name,
		-- Take the array of favorite mix-ins and 
		-- creates one row per favorite mix-in
        unnest(p.favorite_mixins) AS mixin 
    FROM passengers p
),
car_mixins AS (
    SELECT
        c.car_id,
		-- Take the array of available mix-ins and 
		-- creates one row per available mix-in
        unnest(c.available_mixins) AS mixin
    FROM top_cocoa_cars c
)
SELECT DISTINCT
    pm.passenger_name,
    cm.car_id AS cocoa_car_id
FROM passenger_mixins pm
JOIN car_mixins cm
    ON pm.mixin = cm.mixin
ORDER BY pm.passenger_name, cocoa_car_id;


