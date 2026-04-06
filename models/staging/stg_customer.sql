WITH source AS (
    SELECT * FROM {{ source('innovate', 'CUSTOMER') }}
)

SELECT
    CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME,
    EMAIL,
    DATE_OF_BIRTH,
    MEMBER_TYPE,
    {{ dv_hash('CUSTOMER_ID') }}                                                          AS CUSTOMER_HK,
    {{ dv_hash(['FIRST_NAME', 'LAST_NAME', 'EMAIL', 'DATE_OF_BIRTH', 'MEMBER_TYPE']) }}   AS HASH_DIFF,
    CURRENT_TIMESTAMP()                                                                    AS LOAD_DATE,
    'INNOVATE.PUBLIC.CUSTOMER'                                                             AS RECORD_SOURCE
FROM source
