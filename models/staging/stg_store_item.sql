WITH source AS (
    SELECT * FROM {{ source('innovate', 'STORE_ITEM') }}
)

SELECT
    STORE_ID,
    ITEM_ID,
    {{ dv_hash(['STORE_ID', 'ITEM_ID']) }} AS STORE_ITEM_HK,
    {{ dv_hash('STORE_ID') }}              AS STORE_HK,
    {{ dv_hash('ITEM_ID') }}               AS ITEM_HK,
    CURRENT_TIMESTAMP()                     AS LOAD_DATE,
    'INNOVATE.PUBLIC.STORE_ITEM'            AS RECORD_SOURCE
FROM source
