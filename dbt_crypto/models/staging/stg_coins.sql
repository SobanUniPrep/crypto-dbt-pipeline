with source as (
    select * from {{ source('raw', 'raw_coins') }}
),

renamed as (
    select
        -- identifiers
        id                                              as coin_id,
        symbol                                         as coin_symbol,
        name                                           as coin_name,

        -- market data
        current_price::float                           as current_price_usd,
        market_cap::float                              as market_cap_usd,
        market_cap_rank::int                           as market_cap_rank,
        total_volume::float                            as total_volume_usd,
        fully_diluted_valuation::float                 as fully_diluted_valuation_usd,

        -- price changes
        high_24h::float                                as high_24h_usd,
        low_24h::float                                 as low_24h_usd,
        price_change_24h::float                        as price_change_24h_usd,
        price_change_percentage_24h::float             as price_change_pct_24h,
        market_cap_change_24h::float                   as market_cap_change_24h_usd,
        market_cap_change_percentage_24h::float        as market_cap_change_pct_24h,

        -- supply
        circulating_supply::float                      as circulating_supply,
        total_supply::float                            as total_supply,
        max_supply::float                              as max_supply,

        -- all time high/low
        ath::float                                     as ath_usd,
        ath_change_percentage::float                   as ath_change_pct,
        ath_date::timestamp                            as ath_date,
        atl::float                                     as atl_usd,
        atl_change_percentage::float                   as atl_change_pct,
        atl_date::timestamp                            as atl_date,

        -- roi (flatten from json, coalesce nulls to 0)
        coalesce(parse_json(roi):percentage::float, 0) as roi_percentage,
        coalesce(parse_json(roi):times::float, 0)      as roi_times,

        -- metadata
        last_updated::timestamp                        as last_updated_at,
        current_timestamp()                            as dbt_loaded_at

    from source
)

select * from renamed