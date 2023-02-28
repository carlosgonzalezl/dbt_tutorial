{% snapshot sfsd_question %}

{{
    config(
      unique_key='c_questionKey',
      strategy='timestamp',
      updated_at='updatedDate',
      enabled=false
    )
}}

SELECT *
FROM {{ source('SFSD', 'QUESTION') }}

{% endsnapshot %}
