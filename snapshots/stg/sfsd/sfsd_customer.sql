{% snapshot sfsd_customer %}

{{
    config(
      unique_key='c_custkey',
      strategy='check',
      check_cols=['c_name','c_address','c_nationkey','c_phone']
    )
}}

SELECT *
FROM {{ source('SFSD', 'CUSTOMER') }}

{% endsnapshot %}