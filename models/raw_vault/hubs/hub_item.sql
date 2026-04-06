{{
    config(
        materialized='incremental',
        unique_key='ITEM_HK'
    )
}}

WITH staging AS (
    SELECT DISTINCT
        ITEM_HK,
        ITEM_ID,
        LOAD_DATE,
        RECORD_SOURCE
    FROM {{ ref('stg_item') }}
)

SELECT
    s.ITEM_HK,
    s.ITEM_ID,
    s.LOAD_DATE,
    s.RECORD_SOURCE
FROM staging s
{% if is_incremental() %}
    LEFT JOIN {{ this }} t ON s.ITEM_HK = t.ITEM_HK
    WHERE t.ITEM_HK IS NULL
{% endif %}
