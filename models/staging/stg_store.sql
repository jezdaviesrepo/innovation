WITH source AS (
    SELECT * FROM {{ source('innovate', 'STORE') }}
)

SELECT
    STORE_ID,
    NAME,
    LOCATION,
    DESCRIPTION,
    NUMBER_OF_EMPLOYEES,
    {{ dv_hash('STORE_ID') }}                                                AS STORE_HK,
    {{ dv_hash(['NAME', 'LOCATION', 'DESCRIPTION', 'NUMBER_OF_EMPLOYEES']) }} AS HASH_DIFF,
    CURRENT_TIMESTAMP()                                                       AS LOAD_DATE,
    'INNOVATE.PUBLIC.STORE'                                                   AS RECORD_SOURCE
FROM source
