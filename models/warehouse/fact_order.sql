{{config(
    materialized='table',
    tags=['daily']
)}}

WITH orders AS(
    SELECT *
    FROM {{ref('sfsd_order')}}
    WHERE dbt_valid_to is null
),

customers AS(
    SELECT *
    FROM {{ref('dim_customer')}}
),

order_status AS(
    SELECT *
    FROM {{ref('dim_order_status')}}
)

SELECT
    --PK
    md5(o_orderkey)                                                     AS order_id,

    --NK and SK
    o_orderkey                                                          AS order_nk,
    NVL(c.customer_id,'-1')                                             AS customer_id,

    --Other attributes
    TRY_TO_NUMBER(TO_CHAR(o_orderDate,'YYYYMMDD'))                      AS order_date,
    o_orderStatus                                                       AS order_status,
    NVL(os.order_status_desc,'N/A')                                     AS order_status_long,
    o_totalPrice                                                        AS total_price,


    --Audit columns
    CURRENT_TIMESTAMP                                                   AS audt_create_date
FROM orders o
    LEFT JOIN customers c ON o.o_custKey = c.customer_nk
    LEFT JOIN order_status os ON o.o_orderStatus = os.order_status_code