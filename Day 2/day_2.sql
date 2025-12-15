-- Retrieving data from all tables
SELECT * 
FROM snowball_categories;

SELECT * 
FROM snowball_inventory;

-- =================================== THE CHALLENGE ===================================
-- Using the snowball_inventory and snowball_categories tables, write a query that 
-- returns valid snowball categories with the count of valid snowballs per category. 
-- Your final table should have the columns official_category and total_usable_snowballs. 
-- Sort the output from fewest to most total_usable_snowballs.

SELECT 
	sc.official_category,
	COUNT(si.id) AS total_usable_snowballs
FROM snowball_categories sc
LEFT JOIN snowball_inventory si
	ON sc.official_category = si.category_name
WHERE si.status = 'ready'  -- I could also use AND si.status = 'ready' and get the same result.
GROUP BY sc.official_category
ORDER BY total_usable_snowballs ASC;

-- Notice that here I am joining with the category name because there is no numeric foreign key.	

