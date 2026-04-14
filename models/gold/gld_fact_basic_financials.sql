{{ config(materialized='table') }}

with base as (

    select
        pk_basic_financials,
        symbol,
        retrieved_at_utc,
        record_type,
        metric_name,
        period_type,
        period,
        value_num,
        value_str,
        value_date
    from {{ ref('slv_fact_basic_financials') }}
    where symbol is not null

),

resolved as (

    select
        *,
        coalesce(
            value_date,
            cast(retrieved_at_utc as date)
        ) as metric_date
    from base

)

select
    f.pk_basic_financials as pk_basic_financials,

    s.pk_symbol as fk_symbol,
    d.date_key as fk_date_key,

    f.symbol,
    f.retrieved_at_utc,
    f.metric_date,

    f.record_type,
    f.metric_name,
    f.period_type,
    f.period,

    f.value_num,
    f.value_str

from resolved f
left join {{ ref('slv_dim_symbol') }} s
    on f.symbol = s.symbol
left join {{ ref('slv_dim_date') }} d
    on f.metric_date = d.date