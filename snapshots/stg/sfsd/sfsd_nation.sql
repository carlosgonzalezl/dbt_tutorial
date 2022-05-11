{% snapshot sfsd_nation %}

{{
    config(
      unique_key='n_nationkey',
      strategy='check',
      check_cols=['n_name']
    )
}}

SELECT *
FROM {{ source('SFSD', 'NATION') }}

{% endsnapshot %}