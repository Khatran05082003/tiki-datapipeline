WITH dim_date AS (
    SELECT
        *,
        DATE_SUB(CURRENT_DATE(), INTERVAL day_ago_created DAY) AS created_date
    FROM `dwproject-424604.dataset.product`
),
dim_date__calculate AS (
    SELECT 
        created_date AS date_id,
        CAST(created_date AS STRING) AS full_date,
        CASE 
            WHEN EXTRACT(DAYOFWEEK FROM created_date) = 1 THEN 'Sunday'
            WHEN EXTRACT(DAYOFWEEK FROM created_date) = 2 THEN 'Monday'
            WHEN EXTRACT(DAYOFWEEK FROM created_date) = 3 THEN 'Tuesday'
            WHEN EXTRACT(DAYOFWEEK FROM created_date) = 4 THEN 'Wednesday'
            WHEN EXTRACT(DAYOFWEEK FROM created_date) = 5 THEN 'Thursday'
            WHEN EXTRACT(DAYOFWEEK FROM created_date) = 6 THEN 'Friday'
            ELSE 'Saturday'
        END AS day_of_week,
        CASE 
            WHEN EXTRACT(DAYOFWEEK FROM created_date) = 1 THEN 'Sun'
            WHEN EXTRACT(DAYOFWEEK FROM created_date) = 2 THEN 'Mon'
            WHEN EXTRACT(DAYOFWEEK FROM created_date) = 3 THEN 'Tue'
            WHEN EXTRACT(DAYOFWEEK FROM created_date) = 4 THEN 'Wed'
            WHEN EXTRACT(DAYOFWEEK FROM created_date) = 5 THEN 'Thu'
            WHEN EXTRACT(DAYOFWEEK FROM created_date) = 6 THEN 'Fri'
            ELSE 'Sat'
        END AS day_of_week_short,
        CASE 
            WHEN EXTRACT(DAYOFWEEK FROM created_date) IN (1, 7) THEN 'Weekend'
            ELSE 'Weekday'
        END AS is_weekday_or_weekend,
        FORMAT_TIMESTAMP('%d', created_date) AS day_of_month,
        FORMAT_TIMESTAMP('%Y-%m', created_date) AS year_month,
        EXTRACT(MONTH FROM created_date) AS month,
        EXTRACT(DAYOFYEAR FROM created_date) AS day_of_the_year,
        FORMAT_TIMESTAMP('%W', created_date) AS week_of_year,
        EXTRACT(QUARTER FROM created_date) AS quarter_number,
        FORMAT_TIMESTAMP('%Y', created_date) AS year,
        EXTRACT(YEAR FROM created_date) AS year_number
    FROM dim_date
)

SELECT
* 
FROM dim_date__calculate
