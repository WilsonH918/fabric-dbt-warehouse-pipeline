{{ config(materialized='table') }}

select
    pk_transaction_id,
    fk_account_id,
    transaction_date,
    amount
from {{ ref('stg_transactions') }}