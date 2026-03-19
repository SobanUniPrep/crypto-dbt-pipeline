{{ config(materialized='table') }}

with source as (
    select * from {{ ref('stg_coins') }}
),

hub as (
    select distinct
        md5(coin_id)        as hub_coin_hk,
        coin_id             as coin_business_key,
        current_timestamp() as load_date,
        'coingecko'         as record_source
    from source
)

select * from hub