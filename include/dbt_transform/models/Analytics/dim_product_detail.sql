WITH dim_product_detail AS (
    SELECT
        *
    FROM
        `dwproject-424604.dataset.product`
)

,dim_product_detail__cast_type__rename AS (
    SELECT
        CAST(id as INTEGER) as product_id,
        CAST(sku as STRING) as sku,
        CAST(name as STRING) as product_name,
        CAST(type as STRING) as product_type,
        CAST(short_description as STRING) as short_description,
        CAST(inventory_status as STRING) as inventory_status,
        CAST(inventory_type as STRING) as inventory_type,
        CAST(is_fresh as BOOLEAN) as is_fresh
    FROM
        dim_product_detail
)

SELECT
    *
FROM dim_product_detail__cast_type__rename