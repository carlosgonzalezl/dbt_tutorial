{{config(
    materialized='table',
    tags=['daily']
)}}

WITH QUESTIONS AS(
  SELECT * FROM {{ ref('sfsd_question') }}
  WHERE dbt_valid_to IS NULL
),
FINAL AS(
  SELECT
    q.questionId          as question_id,
    q.date                as date_id,
    q.question            as question_desc,
    q.answer              as answer_amt
  FROM QUESTIONS q
)
SELECT * FROM FINAL
