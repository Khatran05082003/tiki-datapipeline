WITH dim_categories AS (
    SELECT
        CAST(JSON_EXTRACT_SCALAR(categories, '$.id') AS INT) AS category_id,
        JSON_EXTRACT_SCALAR(categories, '$.name') AS category_name,
        JSON_EXTRACT_SCALAR(categories, '$.is_leaf') AS is_leaf
    FROM
        `dwproject-424604.dataset.product`
)

,dim_categories__cast_type__rename AS (
    SELECT
        category_id,
        category_name,
        CASE 
            WHEN is_leaf = 'True' THEN TRUE
            ELSE FALSE
        END AS is_leaf
    FROM
        dim_categories
)

SELECT
    category_id,
    category_name,
    is_leaf
FROM dim_categories__cast_type__rename