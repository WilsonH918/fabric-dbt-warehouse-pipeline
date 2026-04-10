{{ config(materialized='view') }}

select
    cast(AccountID as varchar(100)) as account_id,
    AccountType as account_type,
    Balance as balance
from {{ source('lakehouse', 'accounts') }}