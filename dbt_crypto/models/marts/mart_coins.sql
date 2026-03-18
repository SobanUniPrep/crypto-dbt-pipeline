{{
    config(
        materialized='incremental',
        unique_key='coin_id',
        on_schema_change='sync_all_columns'
    )
}}

with source as (
    select * from {{ ref('stg_coins') }}

    {% if is_incremental() %}
        where last_updated_at > (select max(last_updated_at) from {{ this }})
    {% endif %}
),

categories as (
    select * from {{ ref('coin_categories') }}
),

final as (
    select
        s.*,
        coalesce(c.category, 'other')        as category,
        coalesce(c.is_stablecoin, false)      as is_stablecoin
    from source s
    left join categories c using (coin_id)
)

select * from final