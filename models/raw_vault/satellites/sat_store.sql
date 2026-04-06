{{
    config(
        materialized='incremental',
        unique_key=['STORE_HK', 'LOAD_DATE']
    )
}}

WITH staging AS (
    SELECT
        STORE_HK,
        LOAD_DATE,
        RECORD_SOURCE,
        HASH_DIFF,
        NAME,
        LOCATION,
        DESCRIPTION,
        NUMBER_OF_EMPLOYEES
    FROM {{ ref('stg_store') }}
)

SELECT
    s.STORE_HK,
    s.LOAD_DATE,
    CAST(NULL AS TIMESTAMP_NTZ) AS LOAD_END_DATE,
    s.RECORD_SOURCE,
    s.HASH_DIFF,
    s.NAME,
    s.LOCATION,
    s.DESCRIPTION,
    s.NUMBER_OF_EMPLOYEES
FROM staging s
{% if is_incremental() %}
    LEFT JOIN {{ this }} t
        ON s.STORE_HK = t.STORE_HK
        AND t.LOAD_END_DATE IS NULL
    WHERE t.STORE_HK IS NULL
        OR s.HASH_DIFF != t.HASH_DIFF
{% endif %}
