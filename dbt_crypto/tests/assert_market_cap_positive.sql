-- Market cap rank must be positive integer
select *
from {{ ref('stg_coins') }}
where market_cap_rank <= 0