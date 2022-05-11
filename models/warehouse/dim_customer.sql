{{config(
    materialized='table',
    tags=['daily']
)}}

WITH customers AS(
    SELECT *
    FROM {{ref('sfsd_customer')}}
    WHERE dbt_valid_to is null
),

nations AS(
    SELECT *
    FROM {{ref('sfsd_nation')}}
    WHERE dbt_valid_to is null
)

SELECT
    md5(c.c_custkey)            AS customer_id,
    c.c_custkey                 AS customer_nk,
    c.c_name                    AS name,
    c.c_address                 AS address,
    n.n_name                    AS nation_name,
    c.c_phone                   AS phone,
    CURRENT_TIMESTAMP           AS audt_create_date
FROM customers c
    LEFT JOIN nations n ON c.c_nationkey = n.n_nationkey