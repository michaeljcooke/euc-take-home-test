WITH wtd_prep AS(
SELECT
    *,
    ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY tracked_datetime) AS rn
FROM
    weight_tracked_data
)

SELECT
    *
FROM
    wtd_prep
WHERE
    rn = 1
    LIMIT 1;
