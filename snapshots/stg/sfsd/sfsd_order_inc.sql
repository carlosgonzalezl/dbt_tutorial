{% snapshot sfsd_order_inc %}

{%- set timestamp_col = 'o_orderDate' -%}

{%- if table_exists(this) -%}
    {% set _ = run_query('SET LAST_UPDATED = (SELECT MAX('~ timestamp_col ~') FROM  ' ~ this ~ ');') %}
{%- endif -%}

{{
    config(
      unique_key='o_orderkey',
      strategy='timestamp',
      updated_at=timestamp_col
    )
}}

SELECT *
FROM {{ source('SFSD', 'ORDERS') }}
{% if table_exists(this) %}

WHERE o_orderDate > DATEADD(Hour, -4, $LAST_UPDATED)

{% endif %}

{% endsnapshot %}