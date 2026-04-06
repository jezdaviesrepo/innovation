{{
    config(
        materialized='incremental',
        unique_key='STORE_HK'
    )
}}

WITH staging AS (
    SELECT DISTINCT
        STORE_HK,
        STORE_ID,
        LOAD_DATE,
        RECORD_SOURCE
    FROM {{ ref('stg_store') }}
)

SELECT
    s.STORE_HK,
    s.STORE_ID,
    s.LOAD_DATE,
    s.RECORD_SOURCE
FROM staging s
{% if is_incremental() %}
    LEFT JOIN {{ this }} t ON s.STORE_HK = t.STORE_HK
    WHERE t.STORE_HK IS NULL
{% endif %}
