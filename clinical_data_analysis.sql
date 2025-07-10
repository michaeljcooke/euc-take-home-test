WITH most_recent_event_prep AS (
SELECT
    cod.user_id,
    cud.initial_product,
    MIN(tracked_datetime) AS first_event,
    MAX(tracked_datetime) AS last_event
FROM
    weight_tracked_data cod
INNER JOIN
    cleaned_user_data cud ON cod.user_id = cud.id
GROUP BY 1
),

most_recent_event AS(
SELECT
    initial_product,
    AVG(julianday(last_event) - julianday(first_event)) AS avg_time_between_first_last_weight
FROM
    most_recent_event_prep
GROUP BY 1
)


SELECT
    --cud.initial_product,
    --mro.avg_time_between_first_last_weight,
    AVG(cud.age_at_initial_order) AS avg_age,
    AVG(initial_bmi) AS avg_initial_bmi,
    AVG(cud.app_interactions_count) AS avg_app_interactions,
    COUNT(DISTINCT wtd.tracked_id) AS number_events,
    COUNT(DISTINCT CASE WHEN wtd.source = 'INITIAL_CONSULTATION' THEN wtd.tracked_id ELSE NULL END) AS number_initial_events,
    COUNT(DISTINCT CASE WHEN wtd.source = 'FOLLOW_UP_CONSULTATION' THEN wtd.tracked_id ELSE NULL END) AS number_followup_events,
    COUNT(DISTINCT CASE WHEN wtd.source = 'TRACKER' THEN wtd.tracked_id ELSE NULL END) AS number_tracker_events,
    COUNT(DISTINCT cud.id) AS number_users
FROM
    cleaned_user_data cud
INNER JOIN
    weight_tracked_data wtd ON cud.id = wtd.user_id
INNER JOIN
    most_recent_event mro ON cud.initial_product = mro.initial_product
--GROUP BY 1,2;