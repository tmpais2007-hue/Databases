-- 1. Multi-table JOIN with GROUP BY and HAVING
-- Average daily screen time per school, only for schools averaging over 78 minutes
SELECT s.name AS school,
       COUNT(DISTINCT p.participant_id) AS participants,
       ROUND(AVG(u.active_minutes + u.passive_minutes), 1) AS avg_screen_minutes
FROM School s
JOIN Participant p ON p.school_id = s.school_id
JOIN Usage_Log u ON u.participant_id = p.participant_id
GROUP BY s.school_id, s.name
HAVING AVG(u.active_minutes + u.passive_minutes) > 78
ORDER BY avg_screen_minutes DESC;

-- 2. Subquery
-- Participants whose anxiety score is above the overall average
SELECT p.first_name, p.last_name, a.assessed_on, a.anxiety_score,
       (SELECT ROUND(AVG(anxiety_score), 1) FROM Assessment) AS overall_avg
FROM Participant p
JOIN Assessment a ON a.participant_id = p.participant_id
WHERE a.anxiety_score > (SELECT AVG(anxiety_score) FROM Assessment)
ORDER BY a.anxiety_score DESC;

-- 3. Window function
-- Platforms ranked by average incident severity (platforms without incidents rank last)
SELECT pl.name AS platform,
       COUNT(i.incident_id) AS incidents,
       ROUND(AVG(i.severity), 2) AS avg_severity,
       DENSE_RANK() OVER (ORDER BY AVG(i.severity) DESC) AS severity_rank
FROM Platform pl
LEFT JOIN Incident i ON i.platform_id = pl.platform_id
GROUP BY pl.platform_id, pl.name
ORDER BY severity_rank, platform;

-- 4. View combining wellbeing and usage per participant
CREATE OR REPLACE VIEW Participant_Overview AS
SELECT p.participant_id,
       CONCAT(p.first_name, ' ', p.last_name) AS participant,
       s.name AS school,
       d.avg_sleep_hours,
       d.avg_mood,
       u.total_screen_minutes,
       i.incident_count
FROM Participant p
LEFT JOIN School s ON s.school_id = p.school_id
LEFT JOIN (
    SELECT participant_id,
           ROUND(AVG(sleep_hours), 1) AS avg_sleep_hours,
           ROUND(AVG(mood_rating), 1) AS avg_mood
    FROM Daily_Log
    GROUP BY participant_id
) d ON d.participant_id = p.participant_id
LEFT JOIN (
    SELECT participant_id,
           SUM(active_minutes + passive_minutes) AS total_screen_minutes
    FROM Usage_Log
    GROUP BY participant_id
) u ON u.participant_id = p.participant_id
LEFT JOIN (
    SELECT participant_id, COUNT(*) AS incident_count
    FROM Incident
    GROUP BY participant_id
) i ON i.participant_id = p.participant_id;

SELECT * FROM Participant_Overview ORDER BY total_screen_minutes DESC;

-- 5. CTE with CASE
-- Average mood and sleep grouped by how much screen time participants have per day
WITH Daily_Screen AS (
    SELECT participant_id, log_date,
           SUM(active_minutes + passive_minutes) AS screen_minutes
    FROM Usage_Log
    GROUP BY participant_id, log_date
)
SELECT CASE
           WHEN ds.screen_minutes >= 90 THEN 'High (90+ min)'
           WHEN ds.screen_minutes >= 75 THEN 'Medium (75-89 min)'
           ELSE 'Low (< 75 min)'
       END AS usage_level,
       COUNT(*) AS logged_days,
       ROUND(AVG(dl.mood_rating), 2) AS avg_mood,
       ROUND(AVG(dl.sleep_hours), 2) AS avg_sleep_hours
FROM Daily_Screen ds
JOIN Daily_Log dl ON dl.participant_id = ds.participant_id
                 AND dl.log_date = ds.log_date
GROUP BY usage_level
ORDER BY MIN(ds.screen_minutes) DESC;
