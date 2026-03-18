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
)
// this one possibly as macro? reuse in vault

select * from source