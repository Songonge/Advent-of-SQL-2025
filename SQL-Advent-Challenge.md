# Challenge: SQL Advent Calendar by Interview Master

## Day 1
Every year, the city of Whoville conducts a Reindeer Run to find the best reindeers for Santa's Sleigh. Can you write a query to return the name and rank of the top 7 reindeers in this race?

* Tables
reindeer_run_results(number, name, rank, color)

* Query  
```sql
SELECT 
  name,
  rank
FROM reindeer_run_results
ORDER BY rank ASC
LIMIT 7;
```


