SELECT *
FROM hotline_messages;

UPDATE hotline_messages
SET status = 'approved'
WHERE transcript LIKE '%sorry%'
;

DELETE F hotline_messages
SET status = 'approved'
WHERE transcript LIKE '%sorry%'
;

WITH cleaned_messages AS (
	
)
SELECT 
	COUNT(
		CASE
			WHEN status = 'approved' THEN 1
		END ) AS app_mess,
	COUNT(
		CASE
			WHEN status IS NULL THEN 1
		END ) AS rev_mess
FROM hotline_messages
;
