{{
    config(
        materialized='table'
    )
}}

with coins as (
    select * from {{ ref('mart_coins') }}
),

cortex as (
    select
        coin_id,
        coin_name,
        coin_symbol,
        current_price_usd,
        price_change_pct_24h,
        market_cap_usd,
        total_volume_usd,
        ath_change_pct,
        category,
        is_stablecoin,

        snowflake.cortex.complete(
            'mistral-7b',
            'You are a crypto analyst. Based on this data, provide a 2-sentence investment risk assessment in English:
            Coin: ' || coin_name || '
            Current price: $' || current_price_usd || '
            24h price change: ' || price_change_pct_24h || '%
            Market cap: $' || market_cap_usd || '
            Distance from ATH: ' || ath_change_pct || '%
            Category: ' || category || '
            Be concise and factual.'
        ) as risk_summary

    from coins
    where is_stablecoin = false
    limit 10 -- saving tokens
)

select * from cortex