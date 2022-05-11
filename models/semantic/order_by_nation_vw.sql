{{config(
    materialized='view',
    tags=['daily']
)}}

SELECT
    dc.nation_name              AS nation_name,
    fo.order_date               AS order_date,
    SUM(fo.total_price)         AS total_fulfilled_order_price
FROM {{ref('fact_order')}} fo
    JOIN {{ref('dim_customer')}} dc using (customer_id)
WHERE fo.order_status = 'F' --Only fulfilled orders
GROUP BY 1,2