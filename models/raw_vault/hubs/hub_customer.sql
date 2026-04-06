{{
    config(
        materialized='incremental',
        unique_key='CUSTOMER_HK'
    )
}}

WITH staging AS (
    SELECT DISTINCT
        CUSTOMER_HK,
        CUSTOMER_ID,
        LOAD_DATE,
        RECORD_SOURCE
    FROM {{ ref('stg_customer') }}
)

SELECT
    s.CUSTOMER_HK,
    s.CUSTOMER_ID,
    s.LOAD_DATE,
    s.RECORD_SOURCE
FROM staging s
{% if is_incremental() %}
    LEFT JOIN {{ this }} t ON s.CUSTOMER_HK = t.CUSTOMER_HK
    WHERE t.CUSTOMER_HK IS NULL
{% endif %}
