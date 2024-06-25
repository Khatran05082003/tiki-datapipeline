WITH dim_seller AS (
    SELECT
        current_seller,
        price_comparison
    FROM
        `dwproject-424604.dataset.product`
)

, dim_seller__cast_type__rename AS (
    SELECT
        CAST(JSON_EXTRACT_SCALAR(current_seller, '$.store_id') AS INT) AS seller_id,
        CAST(JSON_EXTRACT_SCALAR(current_seller, '$.sku') AS STRING) AS sku,
        CAST(JSON_EXTRACT_SCALAR(current_seller, '$.name') AS STRING) AS seller_name,
        CAST(JSON_EXTRACT_SCALAR(current_seller, '$.link') AS STRING) AS store_link,
        CAST(JSON_EXTRACT_SCALAR(current_seller, '$.is_best_store') AS BOOLEAN) AS is_best_store,
        CAST(JSON_EXTRACT_SCALAR(price_comparison, '$.sub_title') AS STRING) AS price_comparison_with_others,
        CAST(JSON_EXTRACT_SCALAR(price_comparison, '$.title') AS STRING) AS price_comparison_title
    FROM dim_seller
)

SELECT
    *
FROM dim_seller__cast_type__rename
