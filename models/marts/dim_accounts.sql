{{ config(materialized='table') }}

select
    account_id as pk_account_id,
    account_type,
    balance,
    null as test
from {{ ref('stg_accounts') }}