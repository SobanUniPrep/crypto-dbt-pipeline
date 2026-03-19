-- Trading volume cannot be negative
select *
from {{ ref('stg_coins') }}
where total_volume_usd < 0