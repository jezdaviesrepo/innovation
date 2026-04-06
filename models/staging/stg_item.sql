WITH source AS (
    SELECT * FROM {{ source('innovate', 'ITEM') }}
)

SELECT
    ITEM_ID,
    NAME,
    DESCRIPTION,
    BRAND,
    PRICE,
    PRICE_CURRENCY,
    {{ dv_hash('ITEM_ID') }}                                                     AS ITEM_HK,
    {{ dv_hash(['NAME', 'DESCRIPTION', 'BRAND', 'PRICE', 'PRICE_CURRENCY']) }}   AS HASH_DIFF,
    CURRENT_TIMESTAMP()                                                           AS LOAD_DATE,
    'INNOVATE.PUBLIC.ITEM'                                                        AS RECORD_SOURCE
FROM source
