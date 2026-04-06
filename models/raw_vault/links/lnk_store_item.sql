{{
    config(
        materialized='incremental',
        unique_key='STORE_ITEM_HK'
    )
}}

WITH staging AS (
    SELECT DISTINCT
        STORE_ITEM_HK,
        STORE_HK,
        ITEM_HK,
        STORE_ID,
        ITEM_ID,
        LOAD_DATE,
        RECORD_SOURCE
    FROM {{ ref('stg_store_item') }}
)

SELECT
    s.STORE_ITEM_HK,
    s.STORE_HK,
    s.ITEM_HK,
    s.STORE_ID,
    s.ITEM_ID,
    s.LOAD_DATE,
    s.RECORD_SOURCE
FROM staging s
{% if is_incremental() %}
    LEFT JOIN {{ this }} t ON s.STORE_ITEM_HK = t.STORE_ITEM_HK
    WHERE t.STORE_ITEM_HK IS NULL
{% endif %}
