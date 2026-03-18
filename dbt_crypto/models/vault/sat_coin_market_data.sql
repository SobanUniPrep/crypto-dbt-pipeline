{{
    config(
        materialized='incremental',
        on_schema_change='sync_all_columns'
    )
}}

with source as (
    select * from {{ ref('stg_coins') }}

    {% if is_incremental() %}
        where last_updated_at > (select max(last_updated_at) from {{ this }})
    {% endif %}
),

satellite as (
    select
        *,
        current_timestamp() as load_date,
        'coingecko'         as record_source
    from source
)

select * from satellite