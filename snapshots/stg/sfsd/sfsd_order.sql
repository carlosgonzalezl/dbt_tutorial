{% snapshot sfsd_order %}

{{
    config(
      unique_key='o_orderkey',
      strategy='timestamp',
      updated_at='o_orderDate'
    )
}}

SELECT *
FROM {{ source('SFSD', 'ORDERS') }}


{% endsnapshot %}