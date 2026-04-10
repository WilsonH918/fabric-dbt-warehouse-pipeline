{{ config(materialized='table') }}

select
    account_id as pk_account_id,
    account_type,
    balance
from {{ ref('stg_accounts') }}