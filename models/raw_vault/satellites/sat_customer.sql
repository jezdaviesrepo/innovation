{{
    config(
        materialized='incremental',
        unique_key=['CUSTOMER_HK', 'LOAD_DATE']
    )
}}

WITH staging AS (
    SELECT
        CUSTOMER_HK,
        LOAD_DATE,
        RECORD_SOURCE,
        HASH_DIFF,
        FIRST_NAME,
        LAST_NAME,
        EMAIL,
        DATE_OF_BIRTH,
        MEMBER_TYPE
    FROM {{ ref('stg_customer') }}
)

SELECT
    s.CUSTOMER_HK,
    s.LOAD_DATE,
    CAST(NULL AS TIMESTAMP_NTZ) AS LOAD_END_DATE,
    s.RECORD_SOURCE,
    s.HASH_DIFF,
    s.FIRST_NAME,
    s.LAST_NAME,
    s.EMAIL,
    s.DATE_OF_BIRTH,
    s.MEMBER_TYPE
FROM staging s
{% if is_incremental() %}
    LEFT JOIN {{ this }} t
        ON s.CUSTOMER_HK = t.CUSTOMER_HK
        AND t.LOAD_END_DATE IS NULL
    WHERE t.CUSTOMER_HK IS NULL
        OR s.HASH_DIFF != t.HASH_DIFF
{% endif %}
