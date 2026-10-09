-- Queries 1-4: week 3 group queries, written by Peter Leshkov and edited by
-- Tom Piedboeuf, adapted to the real data in week 5 by Peter Leshkov
-- (see README.md, "What broke in the week 3 queries").
-- Queries 5-10: two per group member, documented in query_documentation.md.

-- 1. Multi-table JOIN with GROUP BY and HAVING
-- Average daily screen time per cohort and platform, only where it is over one hour.
-- Cohort = the school, or the data source when the school is unknown.
SELECT COALESCE(s.name, ds.short_name) AS cohort,
    pl.name AS platform,
    COUNT(DISTINCT p.participant_id) AS participants,
    COUNT(*) AS logged_days,
    ROUND(AVG(u.screen_minutes), 1) AS avg_daily_minutes
FROM Usage_Log u
    JOIN Participant p ON p.participant_id = u.participant_id
    JOIN Platform pl ON pl.platform_id = u.platform_id
    LEFT JOIN School s ON s.school_id = p.school_id
    LEFT JOIN Data_Source ds ON ds.source_id = p.source_id
GROUP BY cohort,
    pl.name
HAVING AVG(u.screen_minutes) > 60
ORDER BY cohort,
    avg_daily_minutes DESC;
-- 2. Subquery
-- Participants whose anxiety score is above the overall average.
-- Only dataset B is used: the mock data uses a different anxiety scale.
SELECT p.participant_id,
    p.gender,
    p.age,
    a.anxiety_score,
    a.self_esteem_score,
    a.addiction_score,
    (
        SELECT ROUND(AVG(a2.anxiety_score), 1)
        FROM Assessment a2
            JOIN Participant p2 ON p2.participant_id = a2.participant_id
        WHERE p2.source_id = p.source_id
    ) AS dataset_avg
FROM Participant p
    JOIN Assessment a ON a.participant_id = p.participant_id
    JOIN Data_Source ds ON ds.source_id = p.source_id
WHERE ds.short_name = 'Scafuto2023'
    AND a.anxiety_score > (
        SELECT AVG(a2.anxiety_score)
        FROM Assessment a2
            JOIN Participant p2 ON p2.participant_id = a2.participant_id
        WHERE p2.source_id = p.source_id
    )
ORDER BY a.anxiety_score DESC;
-- 3. Window function
-- Platforms ranked by the average anxiety score of the participants who use them
SELECT pl.name AS platform,
    COUNT(*) AS users,
    ROUND(AVG(a.anxiety_score), 1) AS avg_anxiety,
    ROUND(AVG(a.self_esteem_score), 1) AS avg_self_esteem,
    ROUND(AVG(a.addiction_score), 1) AS avg_addiction,
    DENSE_RANK() OVER (
        ORDER BY AVG(a.anxiety_score) DESC
    ) AS anxiety_rank
FROM Platform pl
    JOIN Platform_Use pu ON pu.platform_id = pl.platform_id
    JOIN Assessment a ON a.participant_id = pu.participant_id
GROUP BY pl.platform_id,
    pl.name
ORDER BY anxiety_rank,
    platform;
-- 4. CTE with CASE
-- Average sleep grouped by how much participants used their phone that day.
-- Uses the 'All smartphone apps' total: the app categories overlap, so
-- adding them up would count some minutes twice.
WITH Daily_Screen AS (
    SELECT u.participant_id,
        u.log_date,
        u.screen_minutes,
        u.bedtime_minutes
    FROM Usage_Log u
        JOIN Platform pl ON pl.platform_id = u.platform_id
    WHERE pl.name = 'All smartphone apps'
)
SELECT CASE
        WHEN ds.screen_minutes >= 540 THEN 'Very high (9+ h)'
        WHEN ds.screen_minutes >= 360 THEN 'High (6-9 h)'
        WHEN ds.screen_minutes >= 180 THEN 'Medium (3-6 h)'
        ELSE 'Low (< 3 h)'
    END AS usage_level,
    COUNT(*) AS logged_days,
    ROUND(AVG(ds.bedtime_minutes), 1) AS avg_bedtime_minutes,
    ROUND(AVG(dl.sleep_hours), 2) AS avg_sleep_hours,
    ROUND(AVG(dl.sleep_quality), 2) AS avg_sleep_quality
FROM Daily_Screen ds
    JOIN Daily_Log dl ON dl.participant_id = ds.participant_id
    AND dl.log_date = ds.log_date
GROUP BY usage_level
ORDER BY MIN(ds.screen_minutes) DESC;

-- 5. Screen time and sleep
-- Author: Tom Piedboeuf
-- Which days had at least six hours of total smartphone use, and how much did
-- the participant sleep that night? The all-apps category avoids double-counting.
SELECT u.participant_id,
    u.log_date,
    u.screen_minutes,
    dl.sleep_hours,
    dl.sleep_quality
FROM Usage_Log u
    JOIN Platform pl ON pl.platform_id = u.platform_id
    JOIN Daily_Log dl ON dl.participant_id = u.participant_id
        AND dl.log_date = u.log_date
WHERE pl.name = 'All smartphone apps'
    AND u.screen_minutes >= 360
ORDER BY u.log_date, u.participant_id;

-- 6. Bedtime screen use and sleep
-- Author: Tom Piedboeuf
-- Which days had at least 30 minutes of smartphone use around bedtime, and
-- how much did the participant sleep that night?
SELECT u.participant_id,
    u.log_date,
    u.bedtime_minutes,
    dl.sleep_hours,
    dl.sleep_quality
FROM Usage_Log u
    JOIN Platform pl ON pl.platform_id = u.platform_id
    JOIN Daily_Log dl ON dl.participant_id = u.participant_id
        AND dl.log_date = u.log_date
WHERE pl.name = 'All smartphone apps'
    AND u.bedtime_minutes >= 30
ORDER BY u.log_date, u.participant_id;

-- 7. Social media time and addiction risk
-- Author: Peter Leshkov
-- Do people who spend more time on social media score higher on addiction
-- and anxiety, and lower on self-esteem? At risk = addiction score 19+.
SELECT CONCAT(a.daily_sm_hours_min, COALESCE(CONCAT('-', a.daily_sm_hours_max), '+'), ' h') AS daily_social_media,
    COUNT(*) AS participants,
    ROUND(AVG(a.addiction_score), 1) AS avg_addiction,
    ROUND(100 * AVG(a.addiction_score >= 19), 1) AS pct_at_risk,
    ROUND(AVG(a.anxiety_score), 1) AS avg_anxiety,
    ROUND(AVG(a.self_esteem_score), 1) AS avg_self_esteem
FROM Assessment a
    JOIN Participant p ON p.participant_id = a.participant_id
    JOIN Data_Source ds ON ds.source_id = p.source_id
WHERE ds.short_name = 'Scafuto2023'
GROUP BY a.daily_sm_hours_min,
    a.daily_sm_hours_max
ORDER BY a.daily_sm_hours_min;

-- 8. Bedtime use compared to the participant's own habit
-- Author: Peter Leshkov
-- Do participants sleep worse on nights when they use their phone around
-- bedtime more than they usually do?
WITH Night AS (
    SELECT u.participant_id,
        u.bedtime_minutes,
        dl.sleep_hours,
        dl.sleep_quality,
        AVG(u.bedtime_minutes) OVER (PARTITION BY u.participant_id) AS own_avg_bedtime
    FROM Usage_Log u
        JOIN Platform pl ON pl.platform_id = u.platform_id
        JOIN Daily_Log dl ON dl.participant_id = u.participant_id
            AND dl.log_date = u.log_date
    WHERE pl.name = 'All smartphone apps'
)
SELECT CASE
        WHEN bedtime_minutes > own_avg_bedtime THEN 'More than usual'
        ELSE 'Usual or less'
    END AS bedtime_use,
    COUNT(*) AS nights,
    COUNT(DISTINCT participant_id) AS participants,
    ROUND(AVG(bedtime_minutes), 1) AS avg_bedtime_minutes,
    ROUND(AVG(sleep_hours), 2) AS avg_sleep_hours,
    ROUND(AVG(sleep_quality), 2) AS avg_sleep_quality
FROM Night
GROUP BY bedtime_use
ORDER BY bedtime_use;


-- 9. Number of platforms and addiction risk
-- Author: Tiago Cornieles Pais
-- Do young people who use more different social media platforms score higher
-- on social media addiction? Average daily hours are shown next to it, because
-- people on more platforms might simply spend more time online.
WITH Platform_Count AS (
    SELECT p.participant_id,
        COUNT(pu.platform_id) AS platforms_used
    FROM Participant p
        JOIN Data_Source ds ON ds.source_id = p.source_id
        LEFT JOIN Platform_Use pu ON pu.participant_id = p.participant_id
    WHERE ds.short_name = 'Scafuto2023'
    GROUP BY p.participant_id
)
SELECT CASE
        WHEN pc.platforms_used <= 1 THEN '0-1 platforms'
        WHEN pc.platforms_used >= 4 THEN '4+ platforms'
        ELSE CONCAT(pc.platforms_used, ' platforms')
    END AS platforms,
    COUNT(*) AS participants,
    ROUND(AVG(a.addiction_score), 1) AS avg_addiction,
    ROUND(100 * AVG(a.addiction_score >= 19), 1) AS pct_at_risk,
    ROUND(AVG(a.self_esteem_score), 1) AS avg_self_esteem,
    ROUND(AVG(a.daily_sm_hours_min), 1) AS avg_daily_sm_hours_min
FROM Platform_Count pc
    JOIN Assessment a ON a.participant_id = pc.participant_id
GROUP BY platforms
ORDER BY MIN(pc.platforms_used);

-- 10. School nights and weekend nights
-- Author: Tiago Cornieles Pais
-- Do participants use their phone more, and spend less time in bed, on school
-- nights than on weekend nights? Friday and Saturday count as weekend nights,
-- because there is no school the next morning.
SELECT CASE
        WHEN DAYOFWEEK(dl.log_date) IN (6, 7) THEN 'Weekend night (Fri-Sat)'
        ELSE 'School night (Sun-Thu)'
    END AS night_type,
    COUNT(*) AS nights,
    COUNT(DISTINCT dl.participant_id) AS participants,
    ROUND(AVG(u.screen_minutes) / 60, 1) AS avg_phone_hours,
    ROUND(AVG(u.bedtime_minutes), 1) AS avg_bedtime_minutes,
    ROUND(AVG(dl.sleep_hours), 2) AS avg_time_in_bed,
    ROUND(AVG(dl.sleep_quality), 2) AS avg_sleep_quality
FROM Daily_Log dl
    JOIN Usage_Log u ON u.participant_id = dl.participant_id
        AND u.log_date = dl.log_date
    JOIN Platform pl ON pl.platform_id = u.platform_id
WHERE pl.name = 'All smartphone apps'
GROUP BY night_type
ORDER BY night_type;
