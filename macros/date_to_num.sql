{% macro date_to_num(date_value) %}
	TRY_TO_NUMBER(TO_CHAR({{date_value}},'YYYYMMDD'))
{% endmacro %}