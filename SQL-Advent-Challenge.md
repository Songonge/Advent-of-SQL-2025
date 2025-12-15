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


## Day 8 Challenge
Mrs. Claus is organizing the holiday storage room and wants a single list of all decorations — both Christmas trees and light sets. Write a query that combines both tables and includes each item's name and category.

### Tables  
* storage_trees(item_name, category)
* storage_lights(item_name, category)

### Query  
```sql
SELECT 
  item_name,
  category
FROM storage_trees
UNION
SELECT 
  item_name,
  category
FROM storage_lights;
```

## Day 9 Challenge
The elves are testing new tinsel–light combinations to find the next big holiday trend. Write a query to generate every possible pairing of tinsel colors and light colors, include in your output a column that combines the two values separated with a dash ("-").

### Tables  
* tinsel_colors(tinsel_id, color_name)
* light_colors(light_id, color_name)

### Query  
```sql
SELECT 
  t.tinsel_id,
  l.light_id,
  CONCAT(t.color_name, '-', l.color_name) AS "tinsel-light"
FROM tinsel_colors t
CROSS JOIN light_colors l;
```

## Day 10 Challenge
In the holiday cookie factory, workers are measuring how efficient each oven is. Can you find the average baking time per oven rounded to one decimal place?

### Tables  
* cookie_batches(batch_id, oven_id, baking_time_minutes)

### Query  
```sql
SELECT
  oven_id,
  ROUND(AVG(baking_time_minutes), 1) AS avg_baking_time
FROM cookie_batches
GROUP BY oven_id;
```

## Day 11 Challenge
At the winter market, Cindy Lou is browsing the clothing inventory and wants to find all items with "sweater" in their name. But the challenge is the color and item columns have inconsistent capitalization. Can you write a query to return only the sweater names and their cleaned-up colors.

### Tables  
* winter_clothing(item_id, item_name, color)

### Query  
```sql
SELECT 
  item_name,
  CONCAT(
    UPPER(LEFT(color, 1)), 
    LOWER(SUBSTRING(color, 2, LENGTH(color)))
  )
FROM winter_clothing
WHERE LOWER(item_name) LIKE '%sweater%';
```

## Day 12 Challenge
The North Pole Network wants to see who's the most active in the holiday chat each day. Write a query to count how many messages each user sent, then find the most active user(s) each day. If multiple users tie for first place, return all of them.

### Tables  
* npn_users(user_id, user_name)
* npn_messages(message_id, sender_id, sent_at)

### Query  
```sql
WITH msg_count AS (
  SELECT
    DATE(m.sent_at) AS message_date,
    u.user_name,
    COUNT(m.message_id) AS total_messages
  FROM npn_users u 
  JOIN npn_messages m 
    ON u.user_id = m.sender_id
  GROUP BY DATE(m.sent_at), u.user_name
),
ranked_users AS (
  SELECT 
    message_date,
    user_name,
    total_messages,
    RANK() OVER (
      PARTITION BY message_date ORDER BY total_messages DESC
    ) AS rk
  FROM msg_count
)
SELECT 
  message_date,
  user_name,
  total_messages
FROM ranked_users
WHERE rk = 1
ORDER BY message_date, total_messages DESC;
```

## Day 13 Challenge
Santa's audit team is reviewing this year's behavior scores to find the extremes — write a query to return the lowest and highest scores recorded on the Naughty or Nice list.

### Tables  
* behavior_scores(record_id, child_name, behavior_score)

### Query  
```sql
SELECT 
  MIN(behavior_score),
  MAX(behavior_score)
FROM behavior_scores;
```


## Day 14 Challenge
The Productivity Club is tracking members' challenge start dates and wants to calculate each member's focus_end_date, exactly 14 days after their start date. Can you write a query to return the existing table with the focus_end_date column?

### Tables  
* focus_challenges(member_id, member_name, start_date)

### Query  
```sql
SELECT 
  *,
  (start_date + INTERVAL '14 days')::DATE AS focus_end_date
FROM focus_challenges;
```


## Day 15 Challenge
The Grinch is tracking his daily mischief scores to see how his behavior changes over time. Can you find how many points his score increased or decreased each day compared to the previous day?

### Tables  
* grinch_mischief_log(log_date, mischief_score)

### Query  






