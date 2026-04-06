{% macro dv_hash(columns) %}
    {% if columns is string %}
        MD5(UPPER(TRIM(CAST({{ columns }} AS VARCHAR))))
    {% else %}
        MD5(UPPER(CONCAT_WS('||',
            {% for col in columns %}
                COALESCE(TRIM(CAST({{ col }} AS VARCHAR)), '^^')
                {%- if not loop.last %}, {% endif %}
            {% endfor %}
        )))
    {% endif %}
{% endmacro %}
