SELECT *
FROM hotline_messages;

-- Checking for records with the word "sorry"
SELECT *
FROM hotline_messages
WHERE transcript LIKE '%sorry%'
; -- This returned 104 records.

-- Updating records with the word "sorry" in the transcript to an approved status.
UPDATE hotline_messages
SET status = 'approved'
WHERE transcript LIKE '%sorry%'
;

-- Checking for records with the tags "penguin prank", "time-loop advisory", "possible dragon", 
-- or "nonsense alert" or if the caller's name is "Test Caller"
SELECT *
FROM hotline_messages
WHERE tag IN ('penguin prank', 'time-loop advisory', 'possible dragon', 'nonsense alert')
	OR caller_name = 'Test Caller'
; -- This returned 89 records.

-- Deleting for records with the tags "penguin prank", "time-loop advisory", "possible dragon", 
-- or "nonsense alert" or if the caller's name is "Test Caller"
DELETE FROM hotline_messages
WHERE tag IN ('penguin prank', 'time-loop advisory', 'possible dragon', 'nonsense alert')
	OR caller_name = 'Test Caller'
; -- This deleted 89 records

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
; -- This returned 477 approved messages and 501 that needs to be reviewed.
