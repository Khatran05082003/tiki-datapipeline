WITH fact_products AS(
    SELECT
        ROW_NUMBER() OVER (ORDER BY id) AS product_line_key,
        id AS product_id,
        CAST(JSON_EXTRACT_SCALAR(categories, '$.id') AS INT) AS category_id,
        DATE_SUB(CURRENT_DATE(), INTERVAL day_ago_created DAY) AS date_id,
        {{ dbt_utils.generate_surrogate_key(['review_text']) }} AS review_id,
        CAST(JSON_EXTRACT_SCALAR(current_seller, '$.store_id') AS INT) AS seller_id,
        CAST(JSON_EXTRACT_SCALAR(stock_item, '$.max_sale_qty') AS INT) AS max_sale_quantity,
        CAST(JSON_EXTRACT_SCALAR(stock_item, '$.min_sale_qty') AS INT) AS min_sale_quantity,
        CAST(JSON_EXTRACT_SCALAR(return_policy, '$.title') AS STRING) AS return_policy,
        CAST(is_tier_pricing_available AS BOOLEAN) AS is_tier_pricing_available,
        CAST(is_tier_pricing_eligible AS BOOLEAN) AS is_tier_pricing_eligible
    FROM  `dwproject-424604.dataset.product`
)
    SELECT
        product_line_key,
        fp.product_id,
        fp.category_id,
        fp.date_id,
        fp.review_id,
        fp.seller_id,
        max_sale_quantity,
        min_sale_quantity,
        is_tier_pricing_available,
        is_tier_pricing_eligible,
        return_policy
    FROM fact_products fp
    LEFT JOIN {{ref('dim_categories')}} dc 
    ON fp.category_id = dc.category_id
    LEFT JOIN {{ref('dim_reviews')}} dr
    ON fp.review_id = dr.review_id
    LEFT JOIN {{ref('dim_seller')}} ds
    ON fp.seller_id = ds.seller_id
    LEFT JOIN {{ref('dim_product_detail')}} dp
    ON fp.product_id = dp.product_id
    LEFT JOIN {{ref('dim_date')}} dd
    ON fp.date_id = dd.date_id
