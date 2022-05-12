{{config(
    materialized='incremental',
    unique_key='order_id',
    tags=['daily']
)}}

{%- if is_incremental() -%}
    {%- set _ = run_query('SET LAST_UPDATED = (SELECT MAX(order_date) FROM  ' ~ this ~ ');') -%}
{%- endif -%}

WITH orders AS(
    SELECT *
    FROM {{ref('sfsd_order_inc')}}
    WHERE dbt_valid_to is null
    {%- if is_incremental() -%}
        AND o_orderDate > DATEADD(Hour, -4, $LAST_UPDATED) --A small overlap in case of late arriving records
    {%- endif -%}
),

customers AS(
    SELECT *
    FROM {{ref('dim_customer')}}
)

SELECT
    --PK
    md5(o.o_orderkey)                                                   AS order_id,

    --NK and SK
    o.o_orderkey                                                        AS order_nk,
    NVL(c.customer_id,'-1')                                             AS customer_id,

    --Other attributes
    o.o_orderDate                                                       AS order_date,
    o.o_orderStatus                                                     AS order_status,
    o.o_totalPrice                                                      AS total_price,

    --Audit columns
    CURRENT_TIMESTAMP                                                   AS audt_create_date
FROM orders o
    LEFT JOIN customers c ON o.o_custKey = c.customer_nk