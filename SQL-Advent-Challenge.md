# Challenge: SQL Advent Calendar by Interview Master

The SQL Advent Challenge is an opportunity for SQL lovers to refresh their SQL knowledge by solving a challenge question every day for 24 days. This runs from December 1st to December 24th of each year. The Challenge is organized by Dawn Choo and her team through their Interview Master platform.

## Day 1 Challenge
Every year, the city of Whoville conducts a Reindeer Run to find the best reindeers for Santa's Sleigh. Can you write a query to return the name and rank of the top 7 reindeers in this race?

### Table
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

### Table  
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
Kevin's trying to decorate the house without sending the electricity bill through the roof. Write a query to find the top 5 most energy-efficient decorations (i.e., lowest cost per hour to operate).

### Table  
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

### Table  
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

### Table  
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
The elves are testing new tinsel–light combinations to find the next big holiday trend. Write a query to generate every possible pairing of tinsel colors and light colors, including in your output a column that combines the two values separated with a dash ("-").

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
In the holiday cookie factory, workers are measuring how efficient each oven is. Can you find the average baking time per oven, rounded to one decimal place?

### Table  
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
At the winter market, Cindy Lou is browsing the clothing inventory and wants to find all items with "sweater" in their name. But the challenge is that the color and item columns have inconsistent capitalization. Can you write a query to return only the sweater names and their cleaned-up colors?

### Table  
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

### Table  
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

### Table  
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

### Table  
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

### Table  
* grinch_mischief_log(log_date, mischief_score)

### Query  
```sql
SELECT 
  log_date,
  mischief_score,
  mischief_score - LAG(mischief_score) OVER (ORDER BY log_date) AS daily_score_diff
FROM grinch_mischief_log;
```


## Day 16 Challenge
It's a snow day, and Buddy is deciding which tasks he can do from under a blanket. Can you find all tasks that are either marked as 'Work From Home' or 'Low Priority' so he can stay cozy and productive?

### Table  
* daily_tasks(task_id, task_name, task_type, priority)

### Query  
```sql
SELECT 
  task_name,
  task_type,
  priority
FROM daily_tasks
WHERE task_type = 'Work From Home' 
  OR priority = 'Low';
```

## Day 17 Challenge
During a quiet evening of reflection, Cindy Lou wants to categorize her tasks based on how peaceful they are. Can you write a query that adds a new column classifying each task as 'Calm' if its noise_level is below 50, and 'Chaotic' otherwise?

### Table  
* evening_tasks(task_id, task_name, noise_level)

### Query  
```sql
SELECT 
  task_name,
  CASE 
    WHEN noise_level < 50 THEN 'Calm'
    ELSE 'Chaotic'
  END task_classification
FROM evening_tasks;
```

## Day 18 Challenge
Over the 12 days of her data challenge, Data Dawn tracked her daily quiz scores across different subjects. Can you find each subject's first and last recorded score to see how much she improved?

### Table  
* daily_quiz_scores(subject, quiz_date, score)

### Query  
```sql
WITH first_date AS (
  SELECT 
    subject,
    MIN(quiz_date) AS min_date
  FROM daily_quiz_scores
GROUP BY subject
),
last_date AS (
  SELECT 
    subject,
    MAX(quiz_date) AS max_date
  FROM daily_quiz_scores
GROUP BY subject
)
SELECT
  f.subject,
  d1.score AS score_first,
  d2.score AS score_last
FROM first_date f 
JOIN daily_quiz_scores d1
  ON d1.subject = f.subject
  AND d1.quiz_date = f.min_date
JOIN last_date l 
  ON l.subject = f.subject
JOIN daily_quiz_scores d2
  ON d2.subject = l.subject
  AND d2.quiz_date = l.max_date;
```

## Day 19 Challenge
Clara is reviewing holiday orders to uncover hidden patterns — can you return the total amount of wrapping paper used for orders that were both gift-wrapped and successfully delivered?

### Table  
* holiday_orders(order_id, customer_name, gift_wrap, paper_used_meters, delivery_status, order_date)

### Query  
```sql
SELECT 
  SUM(paper_used_meters) AS amount_of_wrapping
FROM holiday_orders
WHERE gift_wrap = TRUE
  AND delivery_status = 'Delivered';
```

## Day 20 Challenge
Jack Frost wants to review all the cocoa breaks he actually took — including the cocoa type and the location he drank it in. How would you combine the necessary tables to show each logged break with its matching cocoa details and location?

### Tables  
* cocoa_logs(log_id, break_id, cocoa_id)
* break_schedule(break_id, location_id)
* cocoa_types(cocoa_id, cocoa_name)
* locations(location_id, location_name)

### Query  
```sql
SELECT 
  cl.log_id,
  cl.break_id,
  ct.cocoa_id,
  ct.cocoa_name,
  l.location_name
FROM cocoa_types ct 
JOIN cocoa_logs cl
  ON ct.cocoa_id = cl.cocoa_id
JOIN break_schedule bs 
  ON cl.break_id = bs.break_id
JOIN locations l 
  ON bs.location_id = l.location_id;
```

## Day 21 Challenge
The Snow Queen hosts nightly fireside chats and records how many stories she tells each evening. Can you calculate the running total of stories she has shared over time, in the order they were told?

### Table  
* story_log(log_date, stories_shared)

### Query  
```sql
SELECT 
  SUM(stories_shared) OVER (
    ORDER BY log_date
  ) AS running_total_stories
FROM story_log;
```

## Day 22 Challenge
The penguins are signing up for a community sleigh ride, but the organizers need a list of everyone who did NOT choose the "Evening Ride." How would you return all penguins whose selected time is not the evening slot?

### Table  
* sleigh_ride_signups(signup_id, penguin_name, ride_time)

### Query  
```sql
SELECT 
  signup_id,
  penguin_name,
  ride_time
FROM sleigh_ride_signups
WHERE ride_time <> 'Evening';
```

## Day 23 Challenge
The Gingerbread House Competition wants to feature the builders who used at least 4 distinct candy types in their designs. How would you identify these builders?

### Table  
* gingerbread_designs(builder_id, builder_name, candy_type)

### Query  
```sql
SELECT 
  builder_name,
  COUNT(DISTINCT candy_type) AS candy_type_count
FROM gingerbread_designs
GROUP BY builder_name
HAVING COUNT(DISTINCT candy_type) >= 4;
```

## Day 24 Challenge
As the New Year begins, the goals tracker team wants to understand how user types differ. How many completed goals does the average user have in each user_type?

### Table  
* user_goals(user_id, user_type, goal_id, goal_status)

### Query  
```sql
WITH user_completed_goals AS (
  SELECT 
    user_id,
    user_type,
    COUNT(*) AS goals_completed
  FROM user_goals
  WHERE goal_status = 'Completed'
  GROUP BY user_id, user_type
)
SELECT 
  user_type,
  ROUND(AVG(goals_completed), 2)
FROM user_completed_goals
GROUP BY user_type;
```
