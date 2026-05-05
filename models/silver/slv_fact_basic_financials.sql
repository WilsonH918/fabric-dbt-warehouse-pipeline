{{ config(materialized='table') }}

select
    pk_basic_financials,
    symbol,
    retrieved_at_utc,
    record_type,
    name as metric_name,
    period_type,
    period,
    value_num,
    value_str,
    value_date,
    '' as demo
from {{ source('bronze', 'fact_basic_financials') }}
where symbol is not null
