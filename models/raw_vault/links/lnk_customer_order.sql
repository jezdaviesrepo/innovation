{{
    config(
        materialized='incremental',
        unique_key='CUSTOMER_ORDER_HK'
    )
}}

WITH staging AS (
    SELECT DISTINCT
        CUSTOMER_ORDER_HK,
        CUSTOMER_HK,
        STORE_HK,
        ITEM_HK,
        ORDER_ID,
        CUSTOMER_ID,
        STORE_ID,
        ITEM_ID,
        LOAD_DATE,
        RECORD_SOURCE
    FROM {{ ref('stg_customer_order') }}
)

SELECT
    s.CUSTOMER_ORDER_HK,
    s.CUSTOMER_HK,
    s.STORE_HK,
    s.ITEM_HK,
    s.ORDER_ID,
    s.CUSTOMER_ID,
    s.STORE_ID,
    s.ITEM_ID,
    s.LOAD_DATE,
    s.RECORD_SOURCE
FROM staging s
{% if is_incremental() %}
    LEFT JOIN {{ this }} t ON s.CUSTOMER_ORDER_HK = t.CUSTOMER_ORDER_HK
    WHERE t.CUSTOMER_ORDER_HK IS NULL
{% endif %}
