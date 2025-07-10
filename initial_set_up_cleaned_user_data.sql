.import --csv order_data.csv order_data
.import --csv user_data.csv user_data
.import --csv weight_tracked_data.csv weight_tracked_data
.import --csv cleaned_order_data.csv cleaned_order_data
.import --csv cleaned_user_data.csv cleaned_user_data
.headers on
.mode column

DROP TABLE cleaned_user_data;
CREATE TABLE cleaned_user_data AS
WITH user_data_bmi AS(
SELECT
    ud.*,
    CAST(initial_height AS DECIMAL(18,2))/100.00  AS initial_height_m,
    initial_weight/((CAST(initial_height AS DECIMAL(18,2))/100.00)* (CAST(initial_height AS DECIMAL(18,2))/100.00)) AS initial_bmi,
    ROUND(initial_weight/((CAST(initial_height AS DECIMAL(18,2))/100.00)* (CAST(initial_height AS DECIMAL(18,2))/100.00)),0) AS rounded_initial_bmi
FROM
    user_data ud
),

min_weight AS(
SELECT
    user_id,
    MIN(weight_tracked) AS min_weight
FROM
    weight_tracked_data
GROUP BY 1
)

SELECT
    udb.*,
    initial_weight * 0.8 AS target_weight,
    CASE WHEN min_weight <= (initial_weight * 0.8) THEN TRUE ELSE FALSE END AS is_target_achieved,
    MAX(CASE WHEN julianday(wtd.tracked_datetime) - julianday(initial_order_datetime) BETWEEN 0 AND 90 THEN 1 ELSE 0 END) AS active_three_months,
    MAX(CASE WHEN julianday(wtd.tracked_datetime) - julianday(initial_order_datetime) BETWEEN 91 AND 180 THEN 1 ELSE 0 END) AS active_six_months,
    MAX(CASE WHEN julianday(wtd.tracked_datetime) - julianday(initial_order_datetime) BETWEEN 181 AND 365 THEN 1 ELSE 0 END) AS active_twelve_months
FROM
    user_data_bmi udb
LEFT JOIN
    min_weight mw ON udb.id = mw.user_id
LEFT JOIN
    weight_tracked_data wtd ON udb.id = wtd.user_id
WHERE
    initial_bmi >=27.0000
  OR
    (initial_height >= 142
 AND
    sex_at_birth = 'FEMALE')
  OR
    (initial_height >= 167
 AND
    sex_at_birth = 'MALE')
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
;
*/

/*SELECT
    *
FROM
    user_data_bmi
WHERE
    rounded_initial_bmi >= 85
--GROUP BY 1,2
--ORDER BY initial_weight DESC
;
    
SELECT sex_at_birth, MAX(initial_height) AS max_height FROM user_data GROUP BY 1;

SELECT DISTINCT initial_product FROM user_data;

SELECT * FROM cleaned_user_data;
*/
--exporting cleaned_user_data - this will need to be redone when I've added total orders & total weight lost
.headers on
.mode csv
.output cleaned_user_data.csv
SELECT * FROM cleaned_user_data;
.output stdout
