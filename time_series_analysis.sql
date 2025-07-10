--user signup by campaign source and month
SELECT
    strftime('%Y-%m-01', initial_order_datetime) AS signup_mth,
    campaign_source,
    COUNT(DISTINCT id) AS number_users
FROM
    cleaned_user_data
GROUP BY 1,2
ORDER BY 1,2;

--revenue by month by initial product provided
SELECT
    strftime('%Y-%m-01',cod.order_datetime) AS order_mth,
    cud.initial_product,
    SUM(order_revenue) AS total_revenue
FROM
    cleaned_order_data cod
INNER JOIN
    cleaned_user_data cud ON cod.user_id = cud.id
GROUP BY 1,2
;