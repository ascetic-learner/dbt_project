{% macro generate_asp_odata_source_docs() %}
  {#-
    Queries Snowflake INFORMATION_SCHEMA and prints source YAML with columns.
    Does NOT create any database objects — read-only introspection.
    No external packages required.

    Run in dbt Cloud IDE:
      dbt run-operation generate_asp_odata_source_docs
  -#}

  {% if not execute %}
    {{ return('') }}
  {% endif %}

  {% set column_query %}
    select
      table_name,
      column_name,
      data_type,
      ordinal_position
    from ISOLVED.information_schema.columns
    where table_catalog = 'ISOLVED'
      and table_schema = 'ASP_ODATA'
    order by table_name, ordinal_position
  {% endset %}

  {% set results = run_query(column_query) %}

  {% set lines = [] %}
  {% do lines.append('version: 2') %}
  {% do lines.append('') %}
  {% do lines.append('sources:') %}
  {% do lines.append('  - name: isolved_asp_odata') %}
  {% do lines.append('    description: iSolved payroll OData tables in ISOLVED.ASP_ODATA') %}
  {% do lines.append('    database: ISOLVED') %}
  {% do lines.append('    schema: ASP_ODATA') %}
  {% do lines.append('    tables:') %}

  {% set current_table = '' %}
  {% for row in results %}
    {% set table_name = row[0] %}
    {% set column_name = row[1] %}
    {% set data_type = row[2] %}

    {% if table_name != current_table %}
      {% do lines.append('      - name: ' ~ table_name) %}
      {% do lines.append('        columns:') %}
      {% set current_table = table_name %}
    {% endif %}

    {% do lines.append('          - name: ' ~ column_name) %}
    {% do lines.append('            data_type: ' ~ data_type) %}
  {% endfor %}

  {% for line in lines %}
    {{ log(line, info=true) }}
  {% endfor %}

{% endmacro %}
