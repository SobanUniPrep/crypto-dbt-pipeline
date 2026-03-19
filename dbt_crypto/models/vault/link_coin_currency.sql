{{ config(materialized='table') }}

with coins as (
    select * from {{ ref('hub_coin') }}
),

currencies as (
    select * from {{ ref('hub_currency') }}
),

link as (
    select
        md5(c.coin_business_key || '|' || cur.currency_business_key) as link_coin_currency_hk,
        c.hub_coin_hk,
        cur.hub_currency_hk,
        current_timestamp() as load_date,
        'coingecko'         as record_source
    from coins c
    cross join currencies cur
)

select * from link