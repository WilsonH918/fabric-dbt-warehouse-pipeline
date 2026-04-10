{{ config(materialized='table') }}

select
    -- keys
    f.pk_transaction_id,
    f.fk_account_id,

    -- transaction measures
    f.transaction_date,
    f.amount,

    -- account attributes
    d.account_type,
    d.balance

from {{ ref('fct_transactions') }} f
left join {{ ref('dim_accounts') }} d
    on f.fk_account_id = d.pk_account_id