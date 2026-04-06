WITH source AS (
    SELECT * FROM {{ source('innovate', 'CUSTOMER_ORDER') }}
)

SELECT
    ORDER_ID,
    CUSTOMER_ID,
    STORE_ID,
    ITEM_ID,
    ORDER_DATE,
    QUANTITY,
    {{ dv_hash('ORDER_ID') }}    AS CUSTOMER_ORDER_HK,
    {{ dv_hash('CUSTOMER_ID') }} AS CUSTOMER_HK,
    {{ dv_hash('STORE_ID') }}    AS STORE_HK,
    {{ dv_hash('ITEM_ID') }}     AS ITEM_HK,
    {{ dv_hash(['ORDER_DATE', 'QUANTITY']) }} AS HASH_DIFF,
    CURRENT_TIMESTAMP()          AS LOAD_DATE,
    'INNOVATE.PUBLIC.CUSTOMER_ORDER' AS RECORD_SOURCE
FROM source
