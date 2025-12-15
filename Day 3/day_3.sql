-- Retrieving all data from the table
SELECT *
FROM hotline_messages;

-- ============================ THE CHALLENGE ===========================
-- Using the hotline_messages table, update any record that has 
-- "sorry" (case insensitive) in the transcript and doesn't 
-- currently have a status assigned to have a status of "approved".

-- Then delete any records where the tag is "penguin prank", 
-- "time-loop advisory", "possible dragon", or "nonsense alert" 
-- or if the caller's name is "Test Caller".

-- After updating and deleting the records as described, write a final 
-- query that returns how many messages currently have a status of 
-- "approved" and how many still need to be reviewed (i.e., status is NULL).

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
