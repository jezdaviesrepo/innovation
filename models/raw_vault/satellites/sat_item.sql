{{
    config(
        materialized='incremental',
        unique_key=['ITEM_HK', 'LOAD_DATE']
    )
}}

WITH staging AS (
    SELECT
        ITEM_HK,
        LOAD_DATE,
        RECORD_SOURCE,
        HASH_DIFF,
        NAME,
        DESCRIPTION,
        BRAND,
        PRICE,
        PRICE_CURRENCY
    FROM {{ ref('stg_item') }}
)

SELECT
    s.ITEM_HK,
    s.LOAD_DATE,
    CAST(NULL AS TIMESTAMP_NTZ) AS LOAD_END_DATE,
    s.RECORD_SOURCE,
    s.HASH_DIFF,
    s.NAME,
    s.DESCRIPTION,
    s.BRAND,
    s.PRICE,
    s.PRICE_CURRENCY
FROM staging s
{% if is_incremental() %}
    LEFT JOIN {{ this }} t
        ON s.ITEM_HK = t.ITEM_HK
        AND t.LOAD_END_DATE IS NULL
    WHERE t.ITEM_HK IS NULL
        OR s.HASH_DIFF != t.HASH_DIFF
{% endif %}
