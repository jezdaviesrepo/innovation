{{
    config(
        materialized='incremental',
        unique_key=['CUSTOMER_ORDER_HK', 'LOAD_DATE']
    )
}}

WITH staging AS (
    SELECT
        CUSTOMER_ORDER_HK,
        LOAD_DATE,
        RECORD_SOURCE,
        HASH_DIFF,
        ORDER_DATE,
        QUANTITY
    FROM {{ ref('stg_customer_order') }}
)

SELECT
    s.CUSTOMER_ORDER_HK,
    s.LOAD_DATE,
    CAST(NULL AS TIMESTAMP_NTZ) AS LOAD_END_DATE,
    s.RECORD_SOURCE,
    s.HASH_DIFF,
    s.ORDER_DATE,
    s.QUANTITY
FROM staging s
{% if is_incremental() %}
    LEFT JOIN {{ this }} t
        ON s.CUSTOMER_ORDER_HK = t.CUSTOMER_ORDER_HK
        AND t.LOAD_END_DATE IS NULL
    WHERE t.CUSTOMER_ORDER_HK IS NULL
        OR s.HASH_DIFF != t.HASH_DIFF
{% endif %}
