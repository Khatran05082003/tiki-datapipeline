WITH dim_reviews AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['review_text']) }} AS review_id,
        review_text,
        review_count,
        favourite_count,
        rating_average
    FROM
        `dwproject-424604.dataset.product`
)

,dim_reviews__cast_type__rename AS (
    SELECT
        CAST(review_id AS STRING) AS review_id,
        CAST(review_text AS STRING) AS review_text,
        CAST(review_count AS INTEGER) AS review_count,
        CAST(favourite_count AS INTEGER) AS favorite_count,
        CAST(rating_average AS DECIMAL) AS rating_average
    FROM
        dim_reviews 
)

SELECT
    *
FROM dim_reviews__cast_type__rename
