{{ config(materialized='view') }}

select
    cast(TransactionID as varchar(100)) as pk_transaction_id,
    cast(AccountID as varchar(100)) as fk_account_id,
    TransactionDate as transaction_date,
    Amount as amount
from {{ source('lakehouse', 'transactions') }}