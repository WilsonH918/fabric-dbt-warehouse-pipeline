{{ config(materialized='table') }}

select
    date_key,
    date,
    year,
    quarter,
    month,
    day,
    day_of_week,
    week_of_year,
    is_weekend
from {{ source('bronze', 'dim_date') }}