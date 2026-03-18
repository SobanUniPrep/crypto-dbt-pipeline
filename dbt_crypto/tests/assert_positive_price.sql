-- Prices must never be negative
select *
from {{ ref('stg_coins') }}
where current_price_usd < 0