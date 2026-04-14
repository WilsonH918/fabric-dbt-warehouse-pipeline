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
    web_url
from {{ source('bronze', 'dim_symbol') }}
where symbol is not null
