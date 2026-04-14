{{ config(materialized='table') }}

select
    f.pk_basic_financials as pk_basic_financials,

    f.fk_symbol,
    f.fk_date_key,

    s.symbol,
    s.company_name,
    s.exchange,
    s.country,
    s.currency,
    s.industry,

    d.date as metric_date,
    d.year,
    d.quarter,
    d.month,
    d.week_of_year,
    d.is_weekend,

    f.retrieved_at_utc,
    f.record_type,
    f.metric_name,
    f.period_type,
    f.period,
    f.value_num,
    f.value_str

from {{ ref('gld_fact_basic_financials') }} f
left join {{ ref('gld_dim_symbol') }} s
    on f.fk_symbol = s.pk_symbol
left join {{ ref('gld_dim_date') }} d
    on f.fk_date_key = d.date_key