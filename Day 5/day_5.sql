SELECT *
FROM listening_logs;

-- Write a query that returns the top 3 artists per user. 
-- Order the results by the most played.
WITH playlist AS (
	SELECT 
		user_name,
		artist,
		COUNT(*) AS most_played
	FROM listening_logs
	GROUP BY user_name, artist
),
ranked_artists AS (
	SELECT 
		user_name,
		artist,
		most_played,
		ROW_NUMBER() OVER (
			PARTITION BY user_name, artist 
			ORDER BY most_played DESC
		) AS artist_ranking
	FROM playlist
)
SELECT 
	user_name,
	artist,
	most_played
FROM ranked_artists
WHERE artist_ranking <= 3
ORDER BY most_played DESC
;