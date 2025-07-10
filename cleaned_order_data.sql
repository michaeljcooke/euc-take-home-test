CREATE TABLE cleaned_order_data AS
SELECT
    *
FROM
    order_data
WHERE
    order_datetime <= CURRENT_TIMESTAMP
    ;




