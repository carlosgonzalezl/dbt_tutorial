{% snapshot sfsd_question %}

{{
    config(
      unique_key='c_questionKey',
      strategy='timestamp',
      updatedAt='updatedDate'
    )
}}

SELECT *
FROM {{ source('SFSD', 'QUESTION') }}

{% endsnapshot %}
