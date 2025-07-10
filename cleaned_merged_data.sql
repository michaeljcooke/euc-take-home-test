DROP TABLE cleaned_merged_data;
CREATE TABLE cleaned_merged_data AS
SELECT
    cud.*,
    SUM(cod.order_revenue) AS total_user_spend,
    COUNT(1) AS total_orders
FROM
    cleaned_user_data cud
INNER JOIN
    cleaned_order_data cod ON cud.id = cod.user_id
GROUP BY 1,2,3,4,5,6,7,8;

SELECT
    --campaign_source,
    AVG(age_at_initial_order) AS age_at_first_order,
    ROUND(AVG(initial_bmi),2) AS avg_bmi,
    AVG(app_interactions_count) AS avg_app_interactions
FROM
    cleaned_merged_data
--GROUP BY 1;