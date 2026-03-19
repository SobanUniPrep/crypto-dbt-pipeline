{{ config(materialized='table') }}

with currencies as (
    select distinct
        'usd'               as currency_code
    from {{ ref('stg_coins') }}
),

hub as (
    select
        md5(currency_code)  as hub_currency_hk,
        currency_code       as currency_business_key,
        current_timestamp() as load_date,
        'coingecko'         as record_source
    from currencies
)

select * from hub