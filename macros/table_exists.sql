{% macro table_exists(relation) %}
	{% set table_exists_query %}
		SELECT EXISTS (
			SELECT * 
			FROM {{relation.database}}.INFORMATION_SCHEMA.TABLES
			WHERE TABLE_SCHEMA = UPPER('{{ relation.schema }}') AND TABLE_NAME  = UPPER('{{ relation.identifier }}')
		)
	{% endset %}
	{% if execute %}
		{% set results = run_query(table_exists_query) %}
		{% set exists =  results.columns[0].values()[0] %}
	{% else %}
		{% set exists = True %}
	{% endif %}
	{{ return(exists) }}
{% endmacro %}