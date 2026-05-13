{{ config(materialized='table') }}

select
    pk_symbol,
    symbol,
    company_name,
    exchange,
    country,
    currency,
    industry,
    ipo_date,
    market_cap,
    shares_outstanding,
    web_url,
    'this is for demo' as test
from {{ ref('slv_dim_symbol') }}
where symbol is not null
