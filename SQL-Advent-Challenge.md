# Challenge: SQL Advent Calendar by Interview Master

## Day 1 Challenge
Every year, the city of Whoville conducts a Reindeer Run to find the best reindeers for Santa's Sleigh. Can you write a query to return the name and rank of the top 7 reindeers in this race?

### Tables
reindeer_run_results(number, name, rank, color)

### Query  
```sql
SELECT 
  name,
  rank
FROM reindeer_run_results
ORDER BY rank ASC
LIMIT 7;
```

## Day 2 Challenge
Santa wants to analyze which toys that were produced in his workshop have already been delivered to children. You are given two tables on toy production and toy delivery — can you return the toy ID and toy name of the toys that have been delivered?

### Tables  
* toy_production(toy_id, toy_name, production_date)  
* toy_delivery(toy_id, child_name, delivery_date)

### Query  
```sql
SELECT
  p.toy_name,
  d.toy_id
From toy_production p
INNER JOIN toy_delivery d
  ON p.toy_id = d.toy_id;
```

## Day 3 Challenge
The Grinch has brainstormed a ton of pranks for Whoville, but he only wants to keep the top prank per target, with the highest evilness score. Return the most evil prank for each target. If two pranks have the same evilness, the more recently brainstormed wins.

### Tables  
* grinch_prank_ideas(prank_id, target_name, prank_description, evilness_score, created_at)

### Query  
```sql
WITH rank_score AS (
  SELECT
    target_name,
    evilness_score,
    created_at,
    ROW_NUMBER() OVER (
        PARTITION BY target_name 
        ORDER BY evilness_score DESC, created_at DESC
    ) rn
  FROM grinch_prank_ideas
)
SELECT *
FROM rank_score
WHERE rn = 1;
```

## Day 4 Challenge
Kevin's trying to decorate the house without sending the electricity bill through the roof. Write a query to find the top 5 most energy-efficient decorations (i.e. lowest cost per hour to operate).

### Tables  
* hall_decorations(decoration_id, decoration_name, energy_cost_per_hour)

### Query  
```sql
SELECT
    decoration_name,
    energy_cost_per_hour
FROM hall_decorations
ORDER BY energy_cost_per_hour ASC
LIMIT 5;
```

## Day 5 Challenge
Some elves took time off after the holiday rush, but not everyone has returned to work. List all elves by name, showing their return date. If they have not returned from vacation, list their return date as "Still resting".

### Tables  
* elves(elf_id, elf_name)  
* vacations(elf_id, start_date, return_date)

### Query  
```sql
SELECT
    e.elf_name,
    CASE 
        WHEN v.return_date IS NULL THEN 'Still resting' 
        ELSE return_date
    END AS return_date
FROM elves e
LEFT JOIN vacations v
    ON e.elf_id = v.elf_id;
```

## Day 6 Challenge
Buddy is planning a winter getaway and wants to rank ski resorts by annual snowfall. Can you help him bucket these ski resorts into quartiles?

### Tables  
* resort_monthly_snowfall(resort_id, resort_name, snow_month, snowfall_inches)

### Query  
```sql
WITH annual_snowfall AS (
  SELECT
    resort_id,
    resort_name,
    SUM(snowfall_inches) AS total_annual_snowfall
  FROM resort_monthly_snowfall
  GROUP BY resort_id, resort_name
)
SELECT
  resort_name,
  total_annual_snowfall,
  NTILE(4) OVER (
    ORDER BY total_annual_snowfall DESC
  ) AS quartile_snowfall
FROM annual_snowfall;
```

## Day 7 Challenge
Frosty wants to know how many unique snowflake types were recorded on the December 24th, 2025 storm. Can you help him?

### Tables  
* snowfall_log(flake_id, flake_type, fall_time)

### Query  
```sql
SELECT
  COUNT(DISTINCT flake_type) AS total_unique_snowflake_type
FROM snowfall_log
WHERE fall_time LIKE '2025-12-24%';
```

